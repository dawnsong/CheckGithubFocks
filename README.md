# CheckGithubFocks
## Motivation
Check the latest update date of all the forks of a specified github repository.<br>
I want to know if anyone has translated GraphSAGE from tensorflow 1 with python2.7 to tensorflow 2.1 with python 3.7.

## Example
Checking if anyone has made some changes on his own forks of Hamilton's GraphSAGE:   

> python -u chkForksUpdate.py williamleif GraphSAGE |tee williamleif-GraphSAGE.log 
(note that python -u will not buffer any i/o, thus tee can write to file and terminal immediately)

This will output: 
> #https://github.com/williamleif/GraphSAGE/network/members  
> /williamleif/GraphSAGE : Sep 19, 2018  
> /williamleif/GraphSAGE : Sep 19, 2018  
> /0xf3cd/GraphSAGE : Sep 19, 2018  
> /17385/GraphSAGE : Sep 19, 2018  
> /597477803/GraphSAGE : Sep 19, 2018  
> /978007000/GraphSAGE : Sep 19, 2018  
> ...

## check rate limit  
> curl -o /tmp/githubLimit.json -H "Accept: application/vnd.github.v3+json" https://api.github.com/rate_limit 

## Todo
Get the data through GraphQL API implemented by github, which was originated from Facebook

## GraphQL
GraphQL explorer: https://github.com/graphql/graphiql
Endpoint: https://api.github.com/graphql
Method: Post
HTTP Headers: Authorization="Bearer TOKEN" 
GraphQL: 
> query {
>    repository(owner:"williamleif", name:"GraphSAGE"){    
>     forks(first:10, orderBy:{field:PUSHED_AT	, direction:DESC}) {
>       totalCount  	
>       edges{
>         node{
>           nameWithOwner
>           url
>           updatedAt
>           pushedAt                      
>           ... on Repository{
>             databaseId
>             id
>             forkCount
>             isFork
>           }
>         }      
>         cursor
>       }
>       
> 	    pageInfo {
>         endCursor
>         hasNextPage
>   	  }
>     }
>     
>   }
> }

----------------
> query {
>    repository(owner:"williamleif", name:"GraphSAGE"){    
>     forks(first:10, orderBy:{field:PUSHED_AT	, direction:DESC}) {
>       totalCount  
>       
>       edges{
>         node{          
>           nameWithOwner
>           url
>           updatedAt
>           pushedAt                      
>           ... on Repository{
>             databaseId
>             id
>             forkCount
>             isFork
>             updatedAt
>           }       
>           object(expression: "master"){
>             ... on Commit{
>               history(first:1){
>                 totalCount
>                 nodes{
>                   committedDate
>                 }
>               }
>             }
>           }
>         }      
>         cursor
>       }
>       
> 	    pageInfo {
>         endCursor
>         hasNextPage
>   	  }
>     }
>     
>   }
> }
