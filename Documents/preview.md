# UIViewController의 프리뷰 확인하기

- 프리뷰를 보고싶은 위치에 다음 구조체를 정의

```swift
// import SwiftUI
struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        ViewController().toPreview()
    }
}
```

- PreviewProvider에 대해서는 [여기](https://developer.apple.com/documentation/swiftui/previewprovider)를 참조
- 위에서 UIViewController의 toPreview 메서드는 별도로 구현한 것이며, 구현 내용은 [여기](../PicplzClient/PicplzClient/Support/Extensions/UIViewController+Preview.swift)를 참조
