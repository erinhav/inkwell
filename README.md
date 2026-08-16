# Inkwell

Notification digests. Inkwell batches the events you did not want an email for
individually, renders them into a daily or weekly rollup, and hands the result
to the mail pipeline.

If you have ever wondered why the digest arrived at 09:04 UTC instead of 09:00,
this is the repository to blame.

## What it does

Three things, in order:

1. **Collect.** Reads notification events off the queue and writes them to
   `digest_entries`, keyed by recipient and delivery window.
2. **Roll up.** At the window boundary, groups entries by repository and
   subject, collapses duplicates, and drops anything the recipient has since
   read.
3. **Render and hand off.** Builds the multipart body and enqueues it. Inkwell
   does not talk to SMTP itself.

Anything past step three belongs to the mail pipeline, not to us.

## Getting set up

```
script/bootstrap
script/server
```

`script/bootstrap` expects a local MySQL and will create both
`inkwell_development` and `inkwell_test`. It is safe to run repeatedly.

## Configuration

Credentials come from the environment. `config/database.yml` reads
`MYSQL_HOST`, `MYSQL_USER` and `MYSQL_PASSWORD`, with development defaults that
point at localhost. There is nothing to fill in by hand, and nothing in this
repository should ever contain a real credential.

## Delivery windows

| Digest | Window        | Cutoff    |
| ------ | ------------- | --------- |
| Daily  | 24h           | 09:00 UTC |
| Weekly | 7d, Monday    | 09:00 UTC |

Both are shifted per recipient by a stable hash of the account id, which is why
your digest does not arrive at exactly 09:00 and your neighbour's does.

## Running the tests

```
script/test
```

CI runs the same script. If it passes locally and fails in CI, the difference is
almost always MySQL `sql_mode`.

## Owners

`@github/inkwell`. Ping in `#inkwell` before paging.
