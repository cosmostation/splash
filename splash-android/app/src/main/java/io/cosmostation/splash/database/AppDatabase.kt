package io.cosmostation.splash.database

import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.migration.Migration
import androidx.sqlite.db.SupportSQLiteDatabase
import io.cosmostation.splash.SplashWalletApp

@Database(entities = [Wallet::class], version = 2, exportSchema = false)
abstract class AppDatabase : RoomDatabase() {
    abstract fun walletDao(): WalletDao

    companion object {
        private var instance: AppDatabase? = null

        private val MIGRATION_1_2 = object : Migration(1, 2) {
            override fun migrate(database: SupportSQLiteDatabase) {
                database.execSQL("ALTER TABLE Wallet RENAME TO temp_wallet")
                database.execSQL(
                    "CREATE TABLE IF NOT EXISTS Wallet (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT NOT NULL, address TEXT NOT NULL, encryptedMnemonic TEXT, encryptedPrivateKey TEXT)"
                )
                database.execSQL(
                    "INSERT INTO Wallet (id, name, address, encryptedMnemonic) SELECT id, name, address, encryptedMnemonic FROM temp_wallet"
                )
                database.execSQL("DROP TABLE temp_wallet")
            }
        }

        fun getInstance(): AppDatabase {
            if (instance == null) {
                synchronized(AppDatabase::class) {
                    instance = Room.databaseBuilder(SplashWalletApp.instance, AppDatabase::class.java, "sui_wallet.db").addMigrations(MIGRATION_1_2).build()
                }
            }

            return instance!!
        }
    }
}