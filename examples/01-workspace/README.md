# 00-workspace
This example shows how to restrict creation of backend infrastructure to 
a uses defined workspace.

## Prevents creation in `default` workspace
```
terraform workspace select default
terraform plan
```
The output should be empty

## Create infrastructure in `backend` workspace
```
terraform workspace new backend
terraform plan
```


