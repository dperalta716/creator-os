# fal-ai Skill Learnings

*Accumulated rules from usage feedback. Read before every run.*

- **Always default to quality=low.** Never use `medium` or `high` unless the user explicitly requests it in their message.
- **Status/result URLs strip the operation suffix.** fal.ai's queue status and result URLs use the base model path (e.g. `openai/gpt-image-2/requests/{id}/status`), NOT the operation-specific path (`openai/gpt-image-2/edit/requests/{id}/status`). This was a bug that caused infinite polling — now fixed in fal-common.sh by stripping `/edit` and `/generate` from ENDPOINT before constructing status URLs.
