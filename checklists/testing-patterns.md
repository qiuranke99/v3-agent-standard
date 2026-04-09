# Testing Patterns Checklist

## Test Pyramid
- [ ] Unit tests cover core business logic
- [ ] Integration tests cover module interactions
- [ ] E2E tests cover critical user flows
- [ ] Ratio is reasonable (unit >> integration >> e2e)

## Test Quality
- [ ] Test names describe behavior ("should return error when input is empty")
- [ ] Each test verifies one thing
- [ ] Tests use Arrange-Act-Assert structure
- [ ] Edge cases covered (null, empty, boundary, error path)
- [ ] Tests don't depend on execution order
- [ ] Tests don't depend on external services (mock/stub in place)
- [ ] Bug fixes include regression tests

## Anti-Patterns (should NOT exist)
- [ ] No tests that verify implementation details instead of behavior
- [ ] No sleep/timeout waits for async operations
- [ ] No tests doing too much (>20 lines of arrange)
- [ ] No commented-out tests
- [ ] No test files with 0 assertions
