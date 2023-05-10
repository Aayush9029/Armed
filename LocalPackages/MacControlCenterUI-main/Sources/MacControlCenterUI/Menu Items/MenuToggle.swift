//
//  MenuToggle.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import AppKit
import SwiftUI

/// ``MacControlCenterMenu`` menu item with a toggle state.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MenuToggle<Label: View>: View, MacControlCenterMenuItem, MenuListStateItem {
    @Binding public var isOn: Bool
    public var style: MenuCircleButtonStyle
    public var label: Label?
    public var onClickBlock: (Bool) -> Void

    // MARK: Init - No Label

    public init(
        isOn: Binding<Bool> = .constant(false),
        style: MenuCircleButtonStyle,
        onClick onClickBlock: @escaping (Bool) -> Void = { _ in }
    ) where Label == EmptyView {
        self._isOn = isOn
        self.style = style
        self.label = nil
        self.onClickBlock = onClickBlock
    }

    public init(
        isOn: Binding<Bool> = .constant(false),
        image: Image,
        onClick onClickBlock: @escaping (Bool) -> Void = { _ in }
    ) where Label == EmptyView {
        self._isOn = isOn
        self.style = .init(image: image)
        self.label = nil
        self.onClickBlock = onClickBlock
    }

    // MARK: Init - With String Label

    public init<S>(
        _ title: S,
        isOn: Binding<Bool> = .constant(false),
        style: MenuCircleButtonStyle,
        onClick onClickBlock: @escaping (Bool) -> Void = { _ in }
    ) where S: StringProtocol, Label == Text {
        self.label = Text(title)
        self._isOn = isOn
        self.style = style
        self.onClickBlock = onClickBlock
    }

    public init<S>(
        _ title: S,
        isOn: Binding<Bool> = .constant(false),
        image: Image,
        onClick onClickBlock: @escaping (Bool) -> Void = { _ in }
    ) where S: StringProtocol, Label == Text {
        self.label = Text(title)
        self._isOn = isOn
        self.style = .init(image: image)
        self.onClickBlock = onClickBlock
    }

    // MARK: Init - With LocalizedStringKey Label

    public init(
        _ titleKey: LocalizedStringKey,
        isOn: Binding<Bool> = .constant(false),
        style: MenuCircleButtonStyle,
        onClick onClickBlock: @escaping (Bool) -> Void = { _ in }
    ) where Label == Text {
        self.label = Text(titleKey)
        self._isOn = isOn
        self.style = style
        self.onClickBlock = onClickBlock
    }

    public init(
        _ titleKey: LocalizedStringKey,
        isOn: Binding<Bool> = .constant(false),
        image: Image,
        onClick onClickBlock: @escaping (Bool) -> Void = { _ in }
    ) where Label == Text {
        self.label = Text(titleKey)
        self._isOn = isOn
        self.style = .init(image: image)
        self.onClickBlock = onClickBlock
    }

    // MARK: Init - With Label Closure

    public init(
        isOn: Binding<Bool> = .constant(false),
        style: MenuCircleButtonStyle,
        @ViewBuilder label: @escaping () -> Label,
        onClick onClickBlock: @escaping (Bool) -> Void = { _ in }
    ) {
        self._isOn = isOn
        self.style = style
        self.label = label()
        self.onClickBlock = onClickBlock
    }

    public init(
        isOn: Binding<Bool> = .constant(false),
        image: Image,
        @ViewBuilder label: @escaping () -> Label,
        onClick onClickBlock: @escaping (Bool) -> Void = { _ in }
    ) {
        self._isOn = isOn
        self.style = .init(image: image)
        self.label = label()
        self.onClickBlock = onClickBlock
    }

    // MARK: Init - With Label

    @_disfavoredOverload
    public init(
        isOn: Binding<Bool> = .constant(false),
        style: MenuCircleButtonStyle,
        label: Label,
        onClick onClickBlock: @escaping (Bool) -> Void = { _ in }
    ) {
        self._isOn = isOn
        self.style = style
        self.label = label
        self.onClickBlock = onClickBlock
    }

    @_disfavoredOverload
    public init(
        isOn: Binding<Bool> = .constant(false),
        image: Image,
        label: Label,
        onClick onClickBlock: @escaping (Bool) -> Void = { _ in }
    ) {
        self._isOn = isOn
        self.style = .init(image: image)
        self.label = label
        self.onClickBlock = onClickBlock
    }

    // MARK: Body

    public var body: some View {
        HighlightingMenuItem(height: .controlCenterIconItem) {
            MenuCircleToggle(
                isOn: $isOn,
                controlSize: .menu,
                style: style,
                label: {
                    label
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                },
                onClick: { state in
                    onClickBlock(state)
                }
            )
        }
    }

    // MARK: MenuListStateItem

    public mutating func setState(state: Bool) {
        _isOn = .constant(state)
    }

    public mutating func setItemClicked(_ block: @escaping () -> Void) {
        onClickBlock = { _ in block() }
    }
}
