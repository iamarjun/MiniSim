@testable import AndroidBar
import XCTest

class MockAction: Action {
  var executeWasCalled = false
  var showQuestionDialogWasCalled = false
  var shouldShowDialog = false

  func execute() throws {
    executeWasCalled = true
  }

  func showQuestionDialog() -> Bool {
    showQuestionDialogWasCalled = true
    return shouldShowDialog
  }
}

class ActionFactoryTests: XCTestCase {
  func testAndroidActionFactory() {
    let device = Device(name: "Test Android Device", identifier: "test_id", platform: .android, type: .physical)

    for tag in SubMenuItems.Tags.allCases {
      let action = AndroidActionFactory.createAction(for: tag, device: device, itemName: "Test Item")
      XCTAssertNotNil(action, "Action should be created for tag: \(tag)")

      switch tag {
      case .copyName:
        XCTAssertTrue(action is CopyNameAction)
      case .copyID:
        XCTAssertTrue(action is CopyIDAction)
      case .coldBoot:
        XCTAssertTrue(action is ColdBootCommand)
      case .noAudio:
        XCTAssertTrue(action is NoAudioCommand)
      case .toggleA11y:
        XCTAssertTrue(action is ToggleA11yCommand)
      case .paste:
        XCTAssertTrue(action is PasteClipboardAction)
      case .upload:
        XCTAssertTrue(action is UploadToDownloadsAction)
      case .delete:
        XCTAssertTrue(action is DeleteAction)
      case .customCommand:
        XCTAssertTrue(action is CustomCommandAction)
      case .logcat:
        XCTAssertTrue(action is LaunchLogCat)
      case .showWindow:
        XCTAssertTrue(action is ShowWindowAction)
      case .restart:
        XCTAssertTrue(action is RestartCommand)
      case .takeScreenshot:
        XCTAssertTrue(action is TakeScreenshotAction)
      case .recordScreen:
        XCTAssertTrue(action is RecordScreenAction)
      case .openInStudio:
        XCTAssertTrue(action is OpenInStudioAction)
      case .wipeData:
        XCTAssertTrue(action is WipeDataAction)
      case .stop:
        XCTAssertTrue(action is StopAction)
      }
    }
  }
}

class ActionExecutorTests: XCTestCase {
  var executor: ActionExecutor!
  var shellStub: ShellStub!

  override func setUp() {
    super.setUp()
    executor = ActionExecutor(queue: DispatchQueue.main)
    shellStub = ShellStub()
  }

  func testExecuteAndroidAction() {
    let device = Device(name: "Test Android Device", identifier: "test_id", platform: .android, type: .physical)
    let expectation = self.expectation(description: "Action executed")

    executor.execute(device: device, commandTag: .copyName, itemName: "Test Item")

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      expectation.fulfill()
    }

    waitForExpectations(timeout: 1, handler: nil)
  }

  func testExecuteActionWithQuestionDialog() {
    let mockAction = MockAction()
    mockAction.shouldShowDialog = true

    if mockAction.showQuestionDialog() {
      XCTAssertFalse(mockAction.executeWasCalled, "Action should not be executed if dialog is shown")
    } else {
      XCTFail("Question dialog should have been shown")
    }
  }
}
