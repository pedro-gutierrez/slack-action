# Slack Action

Notify GitHub workflow completion via Slack

## Usage

```yaml
- uses: pedro-gutierrez/slack-action@v5
  name: Notify via Slack
  with:
    slack_webhook: ${{ secrets.SLACK_WEBHOOK_URL }}
    status: success 
```