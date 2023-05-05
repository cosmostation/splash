package io.cosmostation.splash.api

import io.cosmostation.splash.BuildConfig
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Query
import java.util.concurrent.TimeUnit

interface CoingeckoService {
    companion object {
        fun create(): CoingeckoService {
            val host = "https://api.coingecko.com/api/v3/simple/"
            val builder = Retrofit.Builder().baseUrl(host).addConverterFactory(GsonConverterFactory.create())

            if (BuildConfig.DEBUG) {
                val interceptor = HttpLoggingInterceptor()
                interceptor.setLevel(HttpLoggingInterceptor.Level.BODY)
                val client = OkHttpClient.Builder().addInterceptor(interceptor).connectTimeout(10, TimeUnit.SECONDS).build()
                builder.client(client)
            }

            return builder.build().create(CoingeckoService::class.java)
        }
    }

    @GET("price")
    suspend fun price(@Query("ids") ids: Set<String>, @Query("vs_currencies") currencies: String, @Query("include_24hr_change") include_24hr_change: Boolean): Response<Map<String, Map<String, Double>>?>
}