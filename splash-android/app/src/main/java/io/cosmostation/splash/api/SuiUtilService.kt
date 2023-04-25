package io.cosmostation.splash.api

import com.google.gson.GsonBuilder
import io.cosmostation.splash.BuildConfig
import io.cosmostation.splash.model.network.StakeRequest
import io.cosmostation.splash.model.network.TransactionBlock
import io.cosmostation.splash.model.network.UnstakeRequest
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.Body
import retrofit2.http.POST
import java.util.concurrent.TimeUnit

interface SuiUtilService {
    companion object {
        fun create(): SuiUtilService {
            val host = "https://us-central1-splash-wallet-60bd6.cloudfunctions.net"
            val gson = GsonBuilder().setLenient().create()
            val builder = Retrofit.Builder().baseUrl(host).addConverterFactory(GsonConverterFactory.create(gson))

            if (BuildConfig.DEBUG) {
                val interceptor = HttpLoggingInterceptor()
                interceptor.setLevel(HttpLoggingInterceptor.Level.BODY)
                val client = OkHttpClient.Builder().addInterceptor(interceptor).connectTimeout(10, TimeUnit.SECONDS).build()
                builder.client(client)
            }

            return builder.build().create(SuiUtilService::class.java)
        }
    }

    @POST("buildSuiTransactionBlock")
    fun buildSuiTransactionBlock(@Body body: TransactionBlock): Call<String>

    @POST("buildUnstakingRequest")
    fun buildUnstakingRequest(@Body body: UnstakeRequest): Call<String>

    @POST("buildStakingRequest")
    fun buildStakingRequest(@Body body: StakeRequest): Call<String>
}