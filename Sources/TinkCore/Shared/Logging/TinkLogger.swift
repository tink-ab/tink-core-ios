import OSLog

public enum TinkLogger {
    public static func logUsedSDK(version: String, subsystem: String, category: String) {
        let app = OSLog(subsystem: subsystem, category: category)
        let string = "Version: \(version)"
        os_log("%@", log: app, type: .info, string)
    }
}
