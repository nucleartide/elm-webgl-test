# Serve Elm apps.
serve:
	@elm make src/Pixels.elm --output pixels.js
.PHONY: serve
