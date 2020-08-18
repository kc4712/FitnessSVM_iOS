//
//  Calendar.swift
//  planner-swift
//
//  Created by 양정은 on 2016. 3. 17..
//  Copyright © 2016년 이효문. All rights reserved.
//

import Foundation

open class MWCalendar {
    fileprivate var nCalendar: Calendar = Calendar.current;
    
    open var year: Int32 = 0;
    open var month: Int32 = 0;
    open var day: Int32 = 0;
    open var hour: Int32 = 0;
    open var minute: Int32 = 0;
    open var second: Int32 = 0;
    open var weekday: Int32 = 0;
    
    //    init() {
    //        timeZone = NSTimeZone.defaultTimeZone();
    //    }
    
    open class func getInstance() -> MWCalendar {
        return MWCalendar(date: Date())
    }
    
    fileprivate init(date: Date) {
        //super.init(calendarIdentifier: NSCalendarIdentifierGregorian)!;
        //nCalendar.timeZone = NSTimeZone.defaultTimeZone();
        self.date = date;
    }
    
    open func setTimeZone(_ timeZone: TimeZone) {
        nCalendar.timeZone = timeZone;
    }
    
    //var timeZone: NSTimeZone;
    
    open var date: Date {
        set {
            let calendar = nCalendar;
            //calendar.timeZone = nCalendar.timeZone;
            let flag: NSCalendar.Unit = [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day
                , NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second, NSCalendar.Unit.weekday];
            let components = (calendar as NSCalendar).components(flag, from: newValue);
            self.year = Int32(components.year!);
            self.month = Int32(components.month!);
            self.day = Int32(components.day!);
            self.hour = Int32(components.hour!);
            self.minute = Int32(components.minute!);
            self.second = Int32(components.second!);
            self.weekday = Int32(components.weekday!);
        }
        
        get {
            let calendar = nCalendar;
            //calendar.timeZone = nCalendar.timeZone;
            var components = DateComponents();
            components.year = Int(self.year);
            components.month = Int(self.month);
            components.day = Int(self.day);
            components.hour = Int(self.hour);
            components.minute = Int(self.minute);
            components.second = Int(self.second);
            components.weekday = Int(self.weekday);
            
            return calendar.date(from: components)!;
        }
    }
    
    open func getTimeInMillis() -> Int64 {
        return Int64(self.date.timeIntervalSince1970 * 1000);
    }
    
    open func setTimeInMillis(_ millisec: Int64) {
        let date = Date(timeIntervalSince1970: TimeInterval(millisec/1000));
        self.date = date;
    }
    
    open static func currentTimeMillis() -> Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000);
    }
    
    
    open func convert10MIN(time: Int64) -> Int64 {
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd HH:mm"
        let formatTime = Date(timeIntervalSince1970: TimeInterval(time/1000))
        var timeString = format.string(from: formatTime as Date)
        timeString.removeLast()
        timeString.append("0")
        
        let time10MIN:Date = format.date(from: timeString)!
        
        //let LongTo10MIN:Int64 = Int64(time10MIN.timeIntervalSince1970) * 1000
        Log.i("MWCalendar", msg: "시간 10분 변환:\(format.string(from: format.date(from: timeString)!)) \(Int64(time10MIN.timeIntervalSince1970) * 1000) \(time)");
        return Int64(time10MIN.timeIntervalSince1970) * 1000
    }
    
    open func convertToday() -> Int64 {
        let startnowDayTIME:String = " " + "00" + ":" + "00"
        let startnowMonthDayTime:String = String(MWCalendar.getInstance().month) + "/" + String(MWCalendar.getInstance().day) + startnowDayTIME
        let nowDay:String = String(MWCalendar.getInstance().year) + "/" + startnowMonthDayTime
        let format = DateFormatter()
        format.timeZone = TimeZone.current
        format.dateFormat = "yyyy/MM/dd HH:mm"
        let startnowDay:Date = format.date(from: nowDay)!
        return Int64(startnowDay.timeIntervalSince1970) * 1000
    }
}
