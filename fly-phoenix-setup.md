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

On the surface it looks like a _great_ way to deploy Elixir/Phoenix Apps
and they are committed to making the experience great.



## What?

A new way of deploying Elixir/Phoenix apps that will continue to get better because they
[_hired_ Chris McCord](https://github.com/dwyl/learn-devops/issues/72#issuecomment-917442712)
(creator of Phoenix!!)

## Pricing?

Pricing seems "_fair_", or at least _comparable_ to AWS.
See: [learn-devops/issues/72][https://github.com/dwyl/learn-devops/issues/72#issuecomment-945001230]


### Venture Capital (VC) Funding?

Fly.io are funded by
[YCombinator and a few others](https://www.crunchbase.com/organization/fly-io/company_financials)
...
Obviously, we would _prefer_ if they were independent,
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

## Deploy an App

Followed: https://fly.io/docs/getting-started/elixir/ <br />
Created the PR for deploying Hits to Fly.io: https://github.com/dwyl/hits/pull/128 (detailed log in the PR)<br />


The process for deploying a Phoenix App was a bit _long_ ... ⏳ (_lots of steps..._)<br />
But the docs were good and when I got stuck their forum was useful.

## Metrics UI

The Fly.io web interface is still _very_ basic: https://fly.io/apps/hits/metrics?range=172800
![fly-hits-app-metrics-http](https://user-images.githubusercontent.com/194400/140039296-ed327b71-3202-40da-ba7e-33f53bf531b1.png)

![fly-hits-app-metrics-etc](https://user-images.githubusercontent.com/194400/140041027-cf5f9409-3976-4d48-8b05-1d8b75ed0e74.png)

# Conclusion

Fly.io seems to be good so far.
My plan is to check-in with the Hits App on Fly on a weekly basis and see how it's doing.
Right now I'm just stoked that it's working and has fast response times.
