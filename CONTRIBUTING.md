# Contributing to layan-cyber-posh

Contributions, bug reports, and feature requests are welcome!

## Submitting Issues
- Check existing issues before opening a new one.
- Provide your Oh My Posh version (`oh-my-posh version`), your terminal emulator, font, and shell.
- Include a screenshot or terminal transcript if reporting a visual artifact.

## Pull Requests
1. Fork the repository.
2. Create a feature branch (`git checkout -b feat/your-improvement`).
3. If modifying `themes/layan-cyber.omp.toml`, make sure to regenerate the JSON and YAML variants:
   ```bash
   oh-my-posh config export --config themes/layan-cyber.omp.toml --format json --output themes/layan-cyber.omp.json
   oh-my-posh config export --config themes/layan-cyber.omp.toml --format yaml --output themes/layan-cyber.omp.yaml
   ```
4. Verify all theme formats render without errors:
   ```bash
   oh-my-posh print primary --config themes/layan-cyber.omp.toml
   oh-my-posh print primary --config themes/layan-cyber.omp.json
   oh-my-posh print primary --config themes/layan-cyber.omp.yaml
   ```
5. Follow Conventional Commits for commit messages.
6. Open a Pull Request targeting `main`.
