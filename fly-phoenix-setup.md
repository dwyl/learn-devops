# Fly.io

[fly.io](https://fly.io/about/)
is a new type of Platform-as-a-Service (PaaS)
for deploying web Apps/APIs
closer to the people _using_ them.
Much like a 
[Content Delivery Network](https://en.wikipedia.org/wiki/Content_delivery_network)
(CDN)
where there are copies of your `static` content 
stored on "edge" nodes close to the people (devices)
_consuming_ the content,
Fly.io replicates your Application
so that it is closer to the people _using_ it.

## Why?






## What?



## Pricing?

See: [learn-devops/issues/72][https://github.com/dwyl/learn-devops/issues/72#issuecomment-945001230]



### Venture Capital (VC) Funding?

Fly.io are funded by 
[YCombinator and a few others](https://www.crunchbase.com/organization/fly-io/company_financials)
Obviously we would _prefer_ if they were independent,
but we totally understand that 
building this kind of service requires considerable capital investment
in the form of both infrastructure and engineers.

I suspect they are piggy-backing on AWS/GCP/etc 
rather than running their own servers.
But they still have the job of making it all seamless.

<br />

# How?

Following the "_Hands on with Fly_" (getting started guide):
https://fly.io/docs/hands-on/start/

## Instal `flyctl` CLI

https://fly.io/docs/hands-on/installing/

I'm using homebrew on mac so:

```sh
brew install superfly/tap/flyctl
```


Followed: https://fly.io/docs/getting-started/elixir/ <br />
Created the PR: https://github.com/dwyl/hits/pull/128 <br />

