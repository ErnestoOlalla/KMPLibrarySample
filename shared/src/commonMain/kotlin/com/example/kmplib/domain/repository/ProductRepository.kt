package com.example.kmplib.domain.repository

import com.example.kmplib.domain.model.Product

interface ProductRepository {
    suspend fun getProducts(): List<Product>
}
