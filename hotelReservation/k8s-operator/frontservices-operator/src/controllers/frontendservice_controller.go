package controllers

import (
	"context"

	"k8s.io/apimachinery/pkg/runtime"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
	"sigs.k8s.io/controller-runtime/pkg/log"

	mycompanyv1 "frontendservice-operator/api/v1"
)

// FrontendServiceReconciler reconciles a FrontendService object
type FrontendServiceReconciler struct {
	client.Client
	Scheme *runtime.Scheme
}

//+kubebuilder:rbac:groups=mycompany.com,resources=frontendservices,verbs=get;list;watch;create;update;patch;delete
//+kubebuilder:rbac:groups=mycompany.com,resources=frontendservices/status,verbs=get;update;patch
//+kubebuilder:rbac:groups=mycompany.com,resources=frontendservices/finalizers,verbs=update

func (r *FrontendServiceReconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
	_ = log.FromContext(ctx)

	// TODO(user): your logic here

	return ctrl.Result{}, nil
}

// SetupWithManager sets up the controller with the Manager.
func (r *FrontendServiceReconciler) SetupWithManager(mgr ctrl.Manager) error {
	return ctrl.NewControllerManagedBy(mgr).
		For(&mycompanyv1.FrontendService{}).
		Complete(r)
}
