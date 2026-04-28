package com.example.kmplib.domain.usecase

import com.example.kmplib.domain.model.Product
import com.example.kmplib.domain.repository.ProductRepository

class GetProductsUseCase(
    private val repository: ProductRepository
) {
    suspend operator fun invoke(): List<Product> {
        return repository.getProducts()
    }
}
