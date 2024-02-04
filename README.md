# Root User Alarm

## Purpose

It's considered to be a really good idea (someone might even say best practice) to never use your AWS account root user unless absolutely necessary.  That's because in the event of an account compromise, your root user may be your last line of defense.  Having the root user is an atacker's eqivalent of walking into your data center, at that point they control all the locks and carry all the keys.  Therefore, you should do everything you can to ensure your root user can't be accessed (insanely strong password, removing access keys, MFA, etc) and make sure you're alerted if the root user ever performs any kind of action.  Unfortunately, setting up root user alerts is non-trivial, especially for a personal lab/test account.  This Terraform library is designed to ease setting up your root account alerts.

"But I don't have anything important in my AWS account, why do I care?"  You care because resource stealing is a thing.  Folks love to troll for weakly secured AWS accounts and then borrow those to mine bitcoin or eth or whatever cryptocurrency is poopular at the moment.  They can run up your bill but quick, and if they've owned your root user, it's that much harder to shut them down.  Do you have billing alarms yet?  If not, you'll want to get that set up also.

The basic pattern for root account alerts is like so: CloudTrail (all API calls) -> CloudWatch (AWS's logging service) -> CloudWatch Metric (you can configure these for lots of things, in this case we'll be setting up a count of root user actions greater than zero) -> CloudWatch Events (aka EventBridge) -> Simple Notification Service (SNS - which in this case will send you an email).  As I said, not trivial.

## Prerequisites

You'll need an AWS account that you own (hopefully this is obvious) and command line access configured for a user or role capable of setting up/modifying S3, CloudTrail, CloudWatch, Event Bridge, and SNS.  Note, per the earlier comments this should NOT be your root user account.  If you haven't created an IAM user with admin priviledges stop here, back right on up, get an IAM user set up and your root user locked down.  Then come back to me.

You will also need a recent install of Terraform, the open source version is totally fine, we're not fancy up in here. I'll switch this over to OpenTofu (which I haven't tested but should Just Work) in the near future.

AWS CLI and Terraform setup isn't something that I'm going to go into here, but it's really simple.  If you managed to git clone this repository I'm positive it's something you can handle.  You WILL need to have the AWS CLI set all the way up (with a profile for your admin user) and then need to update vars.tf to set your profile correctly.

## Usage

I started by trying to make this as flexible as possible to where it would do things like using existing S3 buckets or an existing CloudTrail, etc.  Unfortunately Terraform doesn't like to work with resources it didn't create itself and so this quickly dissolved into a series of bad ideas.  Therefore, the only thing you can really re-use is if you happen to have an SNS topic already set up to notify you of other events, you can configure CloudWatch to send to it rather than create a new one.

You can set your variables in your terraform command line, or you can set them directly in vars.tf (while you're in there setting your AWS profile name).

`terraform apply -var 'alert_email=smart-user@example.com'` will build the full stack for your root alerts.

 * alert_email - You'll set this to the email address where you want the alerts delivered.
 * user_sns_topic - set this if you want to use an existing SNS queue rather than create a new one, it needs the name rather than the arn.
 
## Final thoughts

That's about it.  This is one of those things that everyone with an AWS account should do, so I wanted to make sure it was easy.  If you have questions or comments you can find me on Mastodon: @benfromkc@infosec.exchange 
