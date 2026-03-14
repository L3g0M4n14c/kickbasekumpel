---
description: 'Use these guidelines when generating or updating tests.'
applyTo: tests/**
---
# Alltagsengelverwaltung Testing Guidelines

## Test conventions
* Write clear, focused tests that verify one behavior at a time
* Use descriptive test names that explain what is being tested and the expected outcome
* Follow Arrange‑Act‑Assert (AAA) pattern: set up test data, execute the code under test, verify results
* Keep tests independent – each test should run in isolation without depending on other tests
* Start with the simplest test case, then add edge cases and error conditions
* Tests should fail for the right reason – verify they catch the bugs they're meant to catch
* Mock or stub external dependencies to keep tests fast and reliable

## Structure
* Place unit tests alongside the code under `AlltagsengelverwaltungTests/` or a `tests/` folder
* Name test files with the suffix `Tests`, e.g. `PDFExportManagerTests.swift`
* Organize tests by feature or class using `// MARK:` comments when appropriate

## Additional notes
* Use `XCTest` framework conventions (setUp/tearDown if needed)
* Format numbers and dates according to German locale where applicable
* When generating sample data, prefer short, readable constants instead of long Lorem Ipsum
