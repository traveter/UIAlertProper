//
//  Created by traveter
//  Copyright (c) 2014 traveter. All rights reserved.
//

import UIKit

// UIAlertControllerとUIAlertViewControllerを使い分ける　(OK, Cancelの2ボタン対応)
public class UIAlertProper : NSObject {

    public typealias AlertClickHandler = () -> ()

    var okHandler: AlertClickHandler?
    var cancelHandler: AlertClickHandler?

    // UIAlertControllerが使用可能か?
    class func canUIAlertController () -> Bool {
        if let alert: AnyClass = NSClassFromString("UIAlertController") {
            return true
        } else {
            return false
        }
    }

    // UIAlertControllerとUIAlertViewを自動で表示を分ける
    public func showOptimalAlertViewController(view: UIViewController!, Title title: String!, Message message: String!,
        okTitle: String?, cancelTitle: String?, okHandler: AlertClickHandler?, cancelHandler: AlertClickHandler?) -> () {

            if (UIAlertProper.canUIAlertController()) {
                println("UIAlertController")
                var ok = UIAlertAction(title: title, style: .Default, handler: { (UIAlertAction) -> Void in
                    okHandler!()
                })
                UIAlertProper.showAlertController(view, title: title, message: message, okHandler: { (UIAlertAction) -> () in
                    if let handler = okHandler {
                        handler()
                    }
                    }, cancelHandler: { (UIAlertAction) -> () in
                        if let handler = cancelHandler {
                            handler()
                        }
                    }, okTitle: okTitle, cancelTitle: cancelTitle)
            } else {
                println("UIAlertView")
                showAlertView(title, message: message, okTitle: okTitle, cancelTitle: cancelTitle, okHandler: okHandler, cancelHandler: cancelHandler)
            }
    }

    // UIAlertControllerとUIAlertViewを自動で表示を分ける(OKボタンのみ)
    public func showOptimalAlertViewControllerWithoutCancel(view: UIViewController!, Title title: String!, Message message: String!,
        okTitle: String?, okHandler: AlertClickHandler?) -> () {

        if (UIAlertProper.canUIAlertController()) {
            var ok = UIAlertAction(title: title, style: .Default, handler: { (UIAlertAction) -> Void in
                okHandler!()
            })
            UIAlertProper.showAlertController(view, title: title, message: message, okHandler: { (UIAlertAction) -> () in
                if let handler = okHandler {
                    handler()
                }
            }, cancelHandler: nil, okTitle: okTitle, cancelTitle: nil)
        } else {
            showAlertView(title, message: message, okTitle: okTitle, cancelTitle: nil, okHandler: okHandler, cancelHandler: nil)
        }
    }

    private class func showAlertController (view: UIViewController!, title: String!, message: String!, okHandler: ((UIAlertAction!) ->())!, cancelHandler: ((UIAlertAction!) ->())?, okTitle: String?, cancelTitle: String?) -> () {

        var alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)

        var cancelWord = "Cancel"
        if let cancel = cancelTitle {
            cancelWord = cancel
        }

        var okWord = "OK"
        if let ok = okTitle {
            okWord = ok
        }

        if let cancel = cancelHandler {
            let cancelAction = UIAlertAction(title: cancelWord, style: .Cancel, handler: cancel)
            alertController.addAction(cancelAction)
        }

        let okAction = UIAlertAction(title: okWord, style: .Default, handler: okHandler)
        alertController.addAction(okAction)

        view.presentViewController(alertController, animated: true, completion: nil)
    }

    private func showAlertView(title: String, message: String, okTitle: String?, cancelTitle: String?, okHandler: AlertClickHandler?, cancelHandler: AlertClickHandler?) {

        class UIAlertViewBlock: UIAlertView, UIAlertViewDelegate {
            typealias Handler = () -> ()
            var okHandler: Handler?
            var cancelHandler: Handler?

            func setOkHandler(handler: Handler) {
                self.delegate = self
                okHandler = handler
            }

            func setCancelHandler(handler: Handler) {
                cancelHandler = handler
            }

            private func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
                if buttonIndex == alertView.cancelButtonIndex {
                    if let handler = cancelHandler {
                        handler()
                    }
                } else {
                    if let handler = okHandler {
                        handler()
                    }
                }
            }
        }

        var okWord = "OK"
        if let ok = okTitle {
            okWord = ok
        }

        // キャンセル時のコールバックが引数に渡されていればキャンセルボタン追加
        if let cancel = cancelHandler {
            var cancelWord = "Cancel"
            if let cancel = cancelTitle {
                cancelWord = cancel
            }
            var alertView = UIAlertViewBlock(title: title, message: message, delegate: nil, cancelButtonTitle: cancelWord, otherButtonTitles: okWord)
            alertView.setCancelHandler({ () -> () in
                cancel()
            })
            if let handler = okHandler {
                alertView.setOkHandler({ () -> () in
                    handler()
                })
            }
            alertView.show()
        } else {
            var alertView = UIAlertViewBlock(title: title, message: message, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: okWord)
            if let handler = okHandler {
                alertView.setOkHandler({ () -> () in
                    handler()
                })
            }
            alertView.show()
        }
    }
}