package io.cosmostation.splash.api

import io.cosmostation.splash.BuildConfig
import io.cosmostation.splash.model.network.Dapp
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import java.util.concurrent.TimeUnit

interface DappService {
    companion object {
        fun create(): DappService {
            val host = "https://raw.githubusercontent.com/cosmostation/splash/main/resources/"
            val builder = Retrofit.Builder().baseUrl(host).addConverterFactory(GsonConverterFactory.create())

            if (BuildConfig.DEBUG) {
                val interceptor = HttpLoggingInterceptor()
                interceptor.setLevel(HttpLoggingInterceptor.Level.BODY)
                val client = OkHttpClient.Builder().addInterceptor(interceptor).connectTimeout(10, TimeUnit.SECONDS).build()
                builder.client(client)
            }

            return builder.build().create(DappService::class.java)
        }
    }

    @GET("dapp.json")
    suspend fun dapp(): Response<List<Dapp>>
}