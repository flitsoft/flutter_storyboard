# storyboard
## TODO
### Bug
0. Fix MediaQuery Bug.
1. kIsWeb conflict
2. MediaQuery.of(context) is wrong on web (uses the Windows instead of the device preview)
3. Map freezes when Time is mocked and interval sets state too many times too quickly


### Current limitations

0. Cannot test data posting
1. Stateful services
2. Builtin UI ( system UI )
3. When time is mocked, microtask assumes 0 time cost


### Improvement
0. Allow simulatneous build and branch off state (Change performance from O(N) .
Terrible time complexity (steps are repeated in order to restore state just to show a single ui change)
1. Allow background building without window focus
2. Add spotlight screen resizing allowing for large devices on smaller screen.
Support multiple screensize with google maps (google maps cannot be transformed with css without introducing interactions and map preloaded zone bugs)
3. Add language option
4. Add feature toggle option
5. Add customizable design option
6. Add realtime time desgin customization (live screens, not screenshoots)
7. Add UX complexity metrics (how long does it take to reach a screen)
8. Add replay session from analytics
9. Add version history exploring