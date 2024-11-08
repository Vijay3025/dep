service : logger mysql gateway admin restaurent user order

all: persistant_claim persistant logger mysql gateway admin restaurent user order


buildpush: build_all push_all #build and push all services

build_all: build_admin build_order build_restaurent build_user  build_gateway build_logger # build all services

push_all : push_admin push_order push_restaurent push_user push_gateway push_logger #push all images


#************************ docker build ********************************
build_user: go_build_user
	echo "docker build user"
	cd ./../Services/User-service && docker build -t vijay2553/user_service:latest .

build_restaurent: go_build_restaurent
	echo "docker build restaurent"
	cd ./../Services/Restaurent-service && docker build -t vijay2553/restaurent_service:latest .

build_order: go_build_order
	echo "docker build order"
	cd ./../Services/Order-service && docker build -t vijay2553/order_service:latest .

build_admin: go_build_admin
	echo "docker build admin"
	cd ./../Services/Admin-service && docker build -t vijay2553/admin_service1:latest .

build_gateway: go_build_gateway
	echo "docker build gateway"
	cd ./../Services/Gateway-service && docker build -t vijay2553/gateway_service:latest .

build_logger: go_build_logger
	echo "docker build gateway"
	cd ./../Services/Logger-service && docker build -t vijay2553/logger_service:latest .


#*********************************** go build ************************************************
go_build_gateway:
	echo "go build gateway"
	cd ./../Services/Gateway-service &&  env GOOS=linux CGO_ENABLED=0 go build -buildvcs=false -o gateway ./application

go_build_user:
	echo "go build user"
	cd ./../Services/User-service &&  env GOOS=linux CGO_ENABLED=0 go build -buildvcs=false -o user ./application

go_build_restaurent:
	echo "go build restaurent"
	cd ./../Services/Restaurent-service &&  env GOOS=linux CGO_ENABLED=0 go build  -buildvcs=false -o restaurent ./application

go_build_order:
	echo "go build order"
	cd ./../Services/Order-service &&  env GOOS=linux CGO_ENABLED=0 go build -buildvcs=false -o  order ./application

go_build_admin:
	echo "go build admin"
	cd ./../Services/Admin-service &&  env GOOS=linux CGO_ENABLED=0 go build -buildvcs=false -o admin ./application

go_build_logger:
	echo "go build logger"
	cd ./../Services/Logger-service &&  env GOOS=linux CGO_ENABLED=0 go build -buildvcs=false -o logger ./application



#********************************** docker push **********************************************
push_user:
	docker push vijay2553/user_service:latest

push_order:
	docker push vijay2553/order_service:latest

push_restaurent:
	docker push vijay2553/restaurent_service:latest

push_admin:
	docker push vijay2553/admin_service1:latest

push_gateway:
	docker push vijay2553/gateway_service:latest

push_logger:
	docker push vijay2553/logger_service:latest

gateway: build_gateway push_gateway delete_gateway kube_gateway

admin: build_admin push_admin delete_admin kube_admin

restaurent: build_restaurent push_restaurent delete_restaurent kube_restaurent

user: build_user push_user delete_user kube_user

order: build_order push_order delete_order kube_order

logger: build_logger push_logger delete_logger kube_logger
	
mysql : delete_mysql kube_mysql 

persistant: delete_pv kube_pv

persistant_claim: delete_pvc kube_pvc

#*******************************kubectl apply ********************************



kube_all: kube_pv kube_pvc kube_mysql kube_logger kube_gateway kube_admin kube_restaurent kube_user kube_order

kube_only: kube_mysql kube_logger kube_gateway kube_admin kube_restaurent kube_user kube_order

kube_pv:
	kubectl apply -f persistant.yml

kube_pvc:
	kubectl apply -f persistant_claim.yml

kube_mysql:
	kubectl apply -f ./mysql.yml
	kubectl apply -f ./mysql-service.yml

kube_logger:
	kubectl apply -f ./logger.yml
	kubectl apply -f ./logger-service.yml


kube_gateway:
	kubectl apply -f ./gateway.yml
	kubectl apply -f ./gateway-service.yml


kube_admin:
	kubectl apply -f ./admin.yml
	kubectl apply -f ./admin-service.yml


kube_restaurent:
	kubectl apply -f ./restaurent.yml
	kubectl apply -f ./restaurent-service.yml


kube_user:
	kubectl apply -f ./user.yml
	kubectl apply -f ./user-service.yml



kube_order:
	kubectl apply -f ./order.yml
	kubectl apply -f ./order-service.yml


#************************************ kubectl delete **********************************************8

delete_all:  delete_mysql delete_logger delete_gateway delete_admin delete_restaurent delete_user delete_order delete_pvc delete_pv

delete_only: delete_mysql delete_logger delete_gateway delete_admin delete_restaurent delete_user delete_order


delete_pv:
	-kubectl delete -f persistant.yml

delete_pvc:
	-kubectl delete -f persistant_claim.yml

delete_mysql:
	-kubectl delete -f ./mysql.yml
	-kubectl delete -f ./mysql-service.yml

delete_logger:
	-kubectl delete -f ./logger.yml
	-kubectl delete -f ./logger-service.yml


delete_gateway:
	-kubectl delete -f ./gateway.yml
	-kubectl delete -f ./gateway-service.yml


delete_admin:
	-kubectl delete -f ./admin.yml
	-kubectl delete -f ./admin-service.yml


delete_restaurent:
	-kubectl delete -f ./restaurent.yml
	-kubectl delete -f ./restaurent-service.yml


delete_user:
	-kubectl delete -f ./user.yml
	-kubectl delete -f ./user-service.yml



delete_order:
	-kubectl delete -f ./order.yml
	-kubectl delete -f ./order-service.yml 




