import Kingfisher

//MARK: - Cache

private let cache = ImageCache.default

func configureCache() {
    cache.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024
    cache.memoryStorage.config.countLimit = 5
    cache.diskStorage.config.sizeLimit = 50 * 1000 * 1000
    cache.memoryStorage.config.expiration = .seconds(300)
    cache.diskStorage.config.expiration = .days(7)
    cache.memoryStorage.config.cleanInterval = 30
}

