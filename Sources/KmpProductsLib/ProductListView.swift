import SwiftUI
import shared

public struct ProductListView: View {
    @StateObject private var viewModel = ProductListObservable()

    public init() {}

    public var body: some View {
        Group {
            if viewModel.state.isLoading {
                ProgressView()
            } else if let error = viewModel.state.error {
                VStack(spacing: 8) {
                    Text(error)
                        .foregroundColor(.red)
                    Button("Retry") {
                        viewModel.retry()
                    }
                }
            } else {
                List(viewModel.state.products, id: \.id) { product in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(product.title)
                            .font(.headline)
                        Text(product.description_)
                            .font(.subheadline)
                            .lineLimit(2)
                        HStack {
                            Spacer()
                            Text("$\(String(format: "%.2f", product.price))")
                                .font(.callout)
                                .foregroundColor(.accentColor)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

class ProductListObservable: ObservableObject {
    @Published var state = ProductListState(isLoading: true, products: [], error: nil)

    private let viewModel: ProductListViewModel
    private var cancellable: Cancellable?

    init() {
        viewModel = KmpLibIosProvider.shared.provideProductListViewModel()
        cancellable = FlowWrapperKt.wrap(viewModel.state).observe { [weak self] newState in
            DispatchQueue.main.async {
                self?.state = newState
            }
        }
    }

    func retry() {
        viewModel.loadProducts()
    }

    deinit {
        cancellable?.cancel()
        viewModel.clear()
    }
}
