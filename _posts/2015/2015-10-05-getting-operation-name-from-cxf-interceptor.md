---
title: getting operation name from cxf interceptor
layout: post
comments: true
---
In my current project we are using CXF and its logging interceptors to automatically log every inboud and outbound call to a web service. We have custom interceptor classes that extends LoggingInInterceptor and LoggingOutInterceptor, to be able to modify the log message. So we wanted to add the operation name so that we could index its value with [Logstash](https://www.elastic.co/products/logstash). As it turned out, CXF couldn't help us here since the interceptor is invoked in a phase where the operation name hasn't been evaluated yet.

## Refreshing my regex skills
So get around this I wrote a method that would take the log message as input, and use regex to extract the first tag that comes after the soap body tag. As most other developers, I have used regex some times but not often enough so I had to get some help from [regex101.com](https://regex101.com/). Here is the whole method:
{% highlight java linenos %}
    String getOperationName(String xml) {
        Matcher matcher = Pattern.compile("(<\\w*:?Body[^>]*>)([^<]*)(<.+?>)").matcher(xml);
        if (!matcher.find()) return "";
        String xmlTagName = matcher.group(3);
        xmlTagName = xmlTagName.substring(1, xmlTagName.length() - 1).replace("/", "").trim();
        xmlTagName = xmlTagName.contains(" ") ? xmlTagName.split(" ")[0] : xmlTagName;
        return xmlTagName.contains(":") ? xmlTagName.split(":")[1] : xmlTagName;
    }
{% endhighlight %}

The regex expression here is divided into three groups. The first one will match the soap body tag with any prefix namespace and attributes. The second group means zero or more repetitions of any sign but <. The third group will match the tag we're interested in. Line #4 is getting the the result from group 3, and line #5 is removing the <> signs and also remove a forward slash in case the tag is closed like <someTag/>. Next line will split by a whitespace in case the tag had attributes on it, and the last line will skip any prefix namespace.

## What about the inbound message?
This technique works fine on the outgoing message, but when we are dealing with the web service response, we don't have the operation name available in the soap message. The solution is to store the operation name in a hash map on the message object like this:
{% highlight java %}
PhaseInterceptorChain.getCurrentMessage().put("operationName", operationName);
{% endhighlight %}
