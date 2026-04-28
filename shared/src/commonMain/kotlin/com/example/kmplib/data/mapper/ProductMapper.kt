package com.example.kmplib.data.mapper

import com.example.kmplib.data.remote.dto.ProductDto
import com.example.kmplib.domain.model.Product

fun ProductDto.toDomain(): Product {
    return Product(
        id = id,
        title = title,
        description = description,
        price = price,
        thumbnail = thumbnail
    )
}
