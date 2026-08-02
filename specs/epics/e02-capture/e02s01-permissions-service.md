STORY KEY: e02-s01
TITLE:     PermissionsService: request and observe Screen Recording, Camera, and Mic authorizations with graceful denial handling
TYPE:      Story
PARENT:    e02
STATUS:    Draft
AUTHOR:    danielvm           DATE: 2026-06-12
MATURITY:  3
SIZE:      M

### 1. Business narrative
Before streaming or recording can start, macOS requires the user to explicitly grant permission to record the Screen, Camera, and Microphone. Without these, the application cannot capture any content. A smooth, guided onboarding that handles permission requests sequentially, detects denials gracefully, and provides clear deep-linking to System Settings is essential to ensure the user gets set up within our 60-second target.

### 2. Value statement
As a solo developer launching BigStream, I want the app to request and manage access to my screen, camera, and microphone, so that I can stream and record with all my feeds active.

### 3. Actors and permissions
- User (external) — grants or denies permissions, clicks deep link.
- PermissionsService (system) — queries and requests authorization, publishes state updates.

### 4. Trigger and preconditions
Trigger: App launches, or the user clicks a permission grant button in the onboarding UI.
Precondition: System permission states are queried from the macOS system framework.

### 5. Main flow and business logic
1. App requests permissions in sequence: Screen Recording, then Camera, then Microphone.
2. System checks current status:
   - Screen Recording via `CGPreflightScreenCaptureAccess()` and triggers via `CGRequestScreenCaptureAccess()`.
   - Camera via `AVCaptureDevice.authorizationStatus(for: .video)` and requests via `AVCaptureDevice.requestAccess(for: .video)`.
   - Microphone via `AVAudioApplication.shared.recordPermission` and requests via `AVAudioApplication.requestRecordPermission()`.
3. If all permissions are granted, `PermissionsService.allGranted` becomes `true` and the flow completes.
Interruption point: System permission dialog blocks execution until user interacts.

### 6. Alternative flows and exceptions
6a. Screen Recording Denied: App detects denial, publishes `PermissionState.denied(.screenRecording)`. Deep link to "Screen Recording" pane enabled.
6b. Camera Denied: App detects denial, publishes `PermissionState.denied(.camera)`. Deep link to "Camera" pane enabled.
6c. Microphone Denied: App detects denial, publishes `PermissionState.denied(.microphone)`. Deep link to "Microphone" pane enabled.

### 7. Interface elements
Context: new
Static elements: none (UI is in e02-s07; this service is infra/logic only).
Dynamic elements: none.

### 8. Domain model
Entities:
- `Permission` enum: `.screenRecording`, `.camera`, `.microphone`
- `PermissionState` enum: `.undetermined`, `.granted`, `.denied(Permission)`

### 9. Integrations and boundaries
- macOS CoreGraphics / ScreenCaptureKit (perennial, direction: out)
- macOS AVFoundation (perennial, direction: out)

### 10. Background processes
Not applicable.

### 11. Notifications
Not applicable.

### 12. Audit and logging
Audited events logged via `JSONLogger`:
- Permission check status.
- User permission grant/denial outcome.

### 13. Solution variabilities
Not applicable.

### 14. Quality attributes *NFR*
- Permission checking completes within 50ms of query.
- UI state updates publish within 16ms of permission detection.

### 15. Security and compliance *NFR*
- No recording of screen or device access is attempted before permissions are verified as `.granted`.
- Compliance: Respects macOS TCC (Transparency, Consent, and Control) security boundary.

### 16. UX and accessibility *NFR*
- Not applicable (Service layer only; UI is in e02-s07).

### 17. Acceptance criteria
Scenario: All permissions granted
  Given PermissionsService is initialized with all system permissions ungranted
  When PermissionsService.requestAll() is called and user grants all prompts
  Then PermissionsService.allGranted is true
  And the state is published as granted

Scenario: Screen recording permission denied (6a)
  Given Screen Recording permission is denied by the user
  When PermissionsService checks status
  Then PermissionsService publishes PermissionState.denied(.screenRecording)
  And clicking System Settings opens the Screen Recording pane

Scenario: Camera permission denied (6b)
  Given Camera permission is denied by the user
  When PermissionsService checks status
  Then PermissionsService publishes PermissionState.denied(.camera)
  And clicking System Settings opens the Camera pane

Scenario: Microphone permission denied (6c)
  Given Microphone permission is denied by the user
  When PermissionsService checks status
  Then PermissionsService publishes PermissionState.denied(.microphone)
  And clicking System Settings opens the Microphone pane

### 18. Out of scope
- SwiftUI onboarding sheet UI (implemented in e02-s07).
- Persistent storage of permission state (queried dynamically from system).

### 19. Open questions
None.

### 20. References
- ADR-0002 (HaishinKit behind StreamEngine).
- macOS 14+ permission guidelines for AVAudioApplication and AVCaptureDevice.
