package com.example.kmplib.presentation

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

class FlowWrapper<T>(private val flow: StateFlow<T>) {
    val value: T get() = flow.value

    fun observe(onChange: (T) -> Unit): Cancellable {
        val job = flow.onEach { onChange(it) }
            .launchIn(CoroutineScope(Dispatchers.Main))
        return object : Cancellable {
            override fun cancel() {
                job.cancel()
            }
        }
    }
}

interface Cancellable {
    fun cancel()
}

fun <T> StateFlow<T>.wrap(): FlowWrapper<T> = FlowWrapper(this)
