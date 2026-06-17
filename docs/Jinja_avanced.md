# Advanced

cf [best practices](https://docs.getdbt.com/best-practices/best-practice-workflows)

## invocation_id

Add  
'{{ invocation_id }}' as invocation_id  
to your queries.  
The UUID shows rows sharing the same run invocation.  
Ideal for debugging snapshots or incremental tables.

## raw

The {% raw %} ... {% endraw %} block is used to output content exactly as it appears  
without interpreting any Jinja expressions or control statements.  
It's helpful when you want to display content that includes Jinja syntax  
without it being processed.
