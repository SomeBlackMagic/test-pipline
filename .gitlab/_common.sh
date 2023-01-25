if [[ ! "$CI_COMMIT_REF_NAME" =~ ^v.* ]]; then
    export KUBE_NAMESPACE=$(kubernetes_namespace_sanitize ${KUBE_NAMESPACE_PREFIX}-${CI_COMMIT_REF_SLUG} 25)
    SERVER_ENV=${DEV_ENV}
fi
if [[ "$CI_COMMIT_REF_NAME" =~ ^v.* ]]; then
    export KUBE_NAMESPACE=$(kubernetes_namespace_sanitize ${KUBE_NAMESPACE_PREFIX}-${PROD_ENV} 25)
    SERVER_ENV=${PROD_ENV}
fi
