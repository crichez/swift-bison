# Contributing Guidelines

Hi, thanks for considering making a contribution to this project! 
This document hopes to give potential contributors some best practices that are specific to
the BSONKit project.

## Development Environment

BSONKit is a pure Swift Package Manager Project that supports all Swift platforms for both 
release and development. The maintainer of this repository uses Visual Studio Code with the 
Swift Server Work Group's Swift language support extension.

This project should build properly on Xcode, but you may encounter similar problems to
those described in issue [#2](https://github.com/crichez/swift-bson/issues/2). These are related
to differences between the Swift open-source toolchain and Xcode's toolchain and are out of my
control for now.

## Discussions

Discussions are a great way to ask questions to other adopters and contributors about a potential
change or addition. This might be related to a bug, feature request, implementation question or
simply a complaint. We encourage clients and contributors to create a discussion post in the
appropriate category to kickstart their contribution without concerns over format or relevance.

## Issues

Issues should follow a specific issue template. If none of the issue templates provided seem
appropriate for your issue, start a discussion post about it. The issue will be better categorized
or the templates will be updated. Deviations from the issue templates where appropriate are
expected and issues will still be considered.

## Pull Requests

All code contributions must submit a pull request and pass the required checks on all platforms.
Code will be reviewed by @crichez before merging, no review request needed. Once again 
contributors are encouraged to leverage discussion posts to submit the intent of their changes
for review before work begins.
