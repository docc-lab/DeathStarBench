package v1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime/schema"
	"sigs.k8s.io/controller-runtime/pkg/scheme"
)

var (
	// GroupVersion is group version used to register these objects
	GroupVersion = schema.GroupVersion{Group: "mycompany.com", Version: "v1"}

	// SchemeBuilder is used to add go types to the GroupVersionKind scheme
	SchemeBuilder = &scheme.Builder{GroupVersion: GroupVersion}

	// AddToScheme adds the types in this group-version to the given scheme.
	AddToScheme = SchemeBuilder.AddToScheme
)

// FrontendServiceSpec defines the desired state of FrontendService
type FrontendServiceSpec struct {
	// INSERT ADDITIONAL SPEC FIELDS
}

// FrontendServiceStatus defines the observed state of FrontendService
type FrontendServiceStatus struct {
	// INSERT ADDITIONAL STATUS FIELD
}

//+kubebuilder:object:root=true
//+kubebuilder:subresource:status

// FrontendService is the Schema for the frontendservices API
type FrontendService struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   FrontendServiceSpec   `json:"spec,omitempty"`
	Status FrontendServiceStatus `json:"status,omitempty"`
}

//+kubebuilder:object:root=true

// FrontendServiceList contains a list of FrontendService
type FrontendServiceList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []FrontendService `json:"items"`
}

func init() {
	SchemeBuilder.Register(&FrontendService{}, &FrontendServiceList{})
}
