package io.cosmostation.splash.database

import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import io.cosmostation.splash.SplashWalletApp

@Database(entities = [Wallet::class], version = 1, exportSchema = false)
abstract class AppDatabase : RoomDatabase() {
    abstract fun walletDao(): WalletDao

    companion object {
        private var instance: AppDatabase? = null

        fun getInstance(): AppDatabase {
            if (instance == null) {
                synchronized(AppDatabase::class) {
                    instance = Room.databaseBuilder(SplashWalletApp.instance, AppDatabase::class.java, "sui_wallet.db").build()
                }
            }

            return instance!!
        }
    }
}