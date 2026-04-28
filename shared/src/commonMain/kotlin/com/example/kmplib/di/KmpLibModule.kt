package com.example.kmplib.di

import com.example.kmplib.data.remote.ProductApi
import com.example.kmplib.data.remote.createHttpClient
import com.example.kmplib.data.repository.ProductRepositoryImpl
import com.example.kmplib.domain.repository.ProductRepository
import com.example.kmplib.domain.usecase.GetProductsUseCase
import com.example.kmplib.presentation.ProductListViewModel
import org.koin.core.context.startKoin
import org.koin.core.module.Module
import org.koin.dsl.KoinAppDeclaration
import org.koin.dsl.module

val dataModule = module {
    single { createHttpClient() }
    single { ProductApi(get()) }
    single<ProductRepository> { ProductRepositoryImpl(get()) }
}

val domainModule = module {
    factory { GetProductsUseCase(get()) }
}

val presentationModule = module {
    factory { ProductListViewModel(get()) }
}

val kmpLibModules: List<Module> = listOf(dataModule, domainModule, presentationModule)

fun initKmpLib(appDeclaration: KoinAppDeclaration = {}) {
    startKoin {
        appDeclaration()
        modules(kmpLibModules)
    }
}
