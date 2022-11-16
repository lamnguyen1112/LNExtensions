
import Foundation

func runInMainThread(execute work: @escaping @convention(block) () -> Swift.Void) {
    DispatchQueue.main.async {
        work()
    }
}
