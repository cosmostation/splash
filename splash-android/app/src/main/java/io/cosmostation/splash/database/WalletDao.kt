package io.cosmostation.splash.database

import androidx.room.*

@Dao
interface WalletDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(wallet: Wallet): Long

    @Delete
    suspend fun delete(wallet: Wallet)

    @Query("select * from wallet")
    suspend fun selectAll(): List<Wallet>

    @Query("select * from wallet where id = :id")
    suspend fun selectById(id: Long): Wallet?
}