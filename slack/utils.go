package slack

import (
	"reflect"
)

// Set set's a key-value pair of a given model
// Pass a model by using reflect.ValueOf(&model)
func Set(model reflect.Value, key string, value interface{}) {
	model.Elem().FieldByName(key).Set(reflect.ValueOf(value))
}
