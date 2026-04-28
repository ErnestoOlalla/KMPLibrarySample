package com.example.kmplib.data.remote

import com.example.kmplib.data.remote.dto.ProductsResponseDto
import io.ktor.client.HttpClient
import io.ktor.client.call.body
import io.ktor.client.request.get

class ProductApi(
    private val client: HttpClient
) {
    suspend fun getProducts(): ProductsResponseDto {
        return client.get("https://dummyjson.com/products").body()
    }
}
