//
//  ViewController.swift
//  iOSSwiftTest
//
//  Created by karos li on 2021/8/18.
//


/// 响应式编程
/*
 https://github.com/ReactiveX/RxSwift
 https://github.com/beeth0ven/RxSwift-Chinese-Documentation
 */

import UIKit
import RxSwift
import RxCocoa

enum MyError: Error {
    case error
}

class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        test3()
    }
    
    func test1() {
        
        do {
            var observable = Observable<Int>.create { observer in
                observer.onNext(22)
                observer.onNext(33)
                observer.onCompleted()
                return Disposables.create {
                    
                }
            }
            
            observable = Observable.of(11, 22, 33)
            
            // observable.take(until: self.rx.deallocated).subscribe，当本类销毁是，就取消订阅
            let dispose = observable.subscribe { event in
                switch event {
                case .next(let element):
                    print("next", element)
                case .error(let error):
                    print("error", error)
                case .completed:
                    print("completed")
                }
            }.dispose()// 一次性订阅
        }
        
        
        do {
            // 延迟 2 秒后，执行定时器，每隔 1 秒执行一次
            let observable = Observable<Int>.timer(.seconds(2), period: .seconds(1), scheduler: MainScheduler.instance)
            observable.map({ "\($0)" }).bind(to: titleLabel.rx.text).disposed(by: bag)// 当回收袋销毁，就取消订阅
        }
        
    }
    
    func test2() {
        let binder = Binder<String>.init(titleLabel) { target, text in
            target.text = text
        }
        
        Observable.just(1).map({ "\($0)" }).bind(to: binder).dispose()
    }
    
    func test3()  {
        let binder = Binder<Bool>.init(button) { target, isHide in
            target.isHidden = isHide
        }
        
        let observable = Observable<Int>.timer(.seconds(1), period: .seconds(1), scheduler: MainScheduler.instance)
//        let _ = observable.map({ $0 % 2 == 0 }).take(until: self.rx.deallocated).bind(to: binder)
        let _ = observable.map({ $0 % 2 == 0 }).take(until: self.rx.deallocated).bind(to: button.rx.hidden)
        
        /*
         
         rx.isHidden 通过 @dynamicMemberLookup 实现的
         
         @dynamicMemberLookup
         public struct Reactive<Base> {
            public subscript<Property>(dynamicMember keyPath: ReferenceWritableKeyPath<Base, Property>) -> Binder<Property> where Base: AnyObject {
                Binder(self.base) { base, value in
                 base[keyPath: keyPath] = value
                }
            }
         }
         */
        let _ = button.rx.isHidden
    }
}


extension Reactive where Base: UIButton {
    public var hidden: Binder<Bool> {
        Binder<Bool>.init(base) { target, isHidden in
            target.isHidden = isHidden
        }
    }
}
