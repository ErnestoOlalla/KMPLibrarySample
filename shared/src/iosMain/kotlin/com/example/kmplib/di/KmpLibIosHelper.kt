package com.example.kmplib.di

import com.example.kmplib.presentation.ProductListViewModel
import org.koin.core.component.KoinComponent
import org.koin.core.component.get

fun startKmpLibIos() {
    initKmpLib()
}

object KmpLibIosProvider : KoinComponent {
    fun provideProductListViewModel(): ProductListViewModel = get()
}
