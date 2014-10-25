# UIAlertProper
---
### UIAlertVIewとUIAlertControllerを意識せずに使い分ける事ができます

UIAlertControllerが使用可能かどうかで判断しています.

###Method
* showOptimalAlertViewController
* showOptimalAlertViewControllerWithoutCancel

### Method Description

#### showOptimalAlertViewController

2つボタン(デフォルト文言: OK, Cancel)のアラートを表示します

Parameter
* view: UIViewController!: AlertControllerは必須
* title: String!
* message: String!
* okTitle: String?
* cancelTitle: String?
* okHandler: AlertClickHandler?: OKボタン押下時に実行される処理(Blocks)
* cancelHandler: AlertClickHandler?: Cancelボタン押下時に実行される処理(Blocks)

Sample Code
```Swift
var alertProper = UIAlertProper()

alertProper.showOptimalAlertViewController(self, Title: "test", Message: "message",
    okTitle: "OK", cancelTitle: "Cancel",
    okHandler: { () -> () in // do something },
    cancelHandler: { () -> () in // do something }) }
```

#### showOptimalAlertViewControllerWithoutCancel

1つボタン(デフォルト文言: OK)のアラートを表示します

Parameter
* view: UIViewController!: AlertControllerは必須
* title: String!
* message: String!
* okTitle: String?
* okHandler: AlertClickHandler?: OKボタン押下時に実行される処理(Blocks)

Sample Code
```Swift
var alertProper = UIAlertProper()
alertProper.showOptimalAlertViewControllerWithoutCancel(self, Title: "test", Message: "message", okTitle: "ok") { () -> () in // do something }
```
---
## LICENSE
This software is released under the MIT License, see LICENSE.txt.
