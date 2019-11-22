import Foundation

extension Date {
    func dateConverter(value: Date) -> (String, String) {
        let dateFormatter = DateFormatter()
        let hourFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        hourFormatter.dateStyle = .none
        hourFormatter.timeStyle = .short
        let date = dateFormatter.string(from: value)
        let hour = hourFormatter.string(from: value)
        return (date, hour)
    }

    func stringToDate(time: String, date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        let fullDate = date + time
        guard let date = dateFormatter.date(from: fullDate) else { return Date() }
        print(date)
        return date
    }
}
