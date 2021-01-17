//
//  ImageLoader.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/24/20.
//

import Combine
import UIKit

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
    private let url: URL

    private var cancellable: AnyCancellable?
    private var cache: ImageCache?

    private(set) var isLoading = false

    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
        self.load()
    }

    deinit {
        cancel()
    }

    // MARK: - Public methods

    func load() {
        guard !isLoading else { return }

        if let image = cache?[url] {
            self.image = image
            return
        }

        self.cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: Self.imageProcessingQueue)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(
                receiveSubscription: { [weak self] _ in self?.onStart() },
                receiveOutput: { [weak self] in self?.cache($0) },
                receiveCompletion: { [weak self] _ in self?.onFinish() },
                receiveCancel: { [weak self] in self?.onFinish() }
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }

    func cancel() {
        self.cancellable?.cancel()
    }

    // MARK: - Private methods

    private func cache(_ image: UIImage?) {
        image.map { cache?[url] = $0 }
    }

    private func onStart() {
        isLoading = true
    }

    private func onFinish() {
        isLoading = false
    }
}
