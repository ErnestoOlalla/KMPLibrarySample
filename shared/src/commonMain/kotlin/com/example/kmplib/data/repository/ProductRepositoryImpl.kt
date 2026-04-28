package com.example.kmplib.data.repository

import com.example.kmplib.data.mapper.toDomain
import com.example.kmplib.data.remote.ProductApi
import com.example.kmplib.domain.model.Product
import com.example.kmplib.domain.repository.ProductRepository

class ProductRepositoryImpl(
    private val api: ProductApi
) : ProductRepository {

    override suspend fun getProducts(): List<Product> {
        return api.getProducts().products.map { it.toDomain() }
    }
}
