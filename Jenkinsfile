#!groovy

def gitBranch = ''
def gitCommit = ''

def wrapId = { String credentialsId ->
  [[
    $class: 'StringBinding',
    credentialsId: credentialsId,
    variable: 'REGISTRY_PASSWORD',
  ]]
}

def registries = [
  quay: [
    staging: [
      name: 'quay-staging',
      email: 'deisci+jenkins@deis.com',
      username: 'deisci+jenkins',
      credentials: wrapId('c67dc0a1-c8c4-4568-a73d-53ad8530ceeb'),
    ],
    production: [
      name: 'quay-production',
      email: 'deis+jenkins@deis.com',
      username: 'deis+jenkins',
      credentials: wrapId('8317a529-10f7-40b5-abd4-a42f242f22f0'),
    ],
  ],
  dockerhub: [
    staging: [
      name: 'dockerhub-staging',
      email: 'dummy-address@deis.com',
      username: 'deisbot',
      credentials: wrapId('0d1f268f-407d-4cd9-a3c2-0f9671df0104'),
    ],
    production: [
      name: 'dockerhub-production',
      email: 'dummy-address@deis.com',
      username: 'deisbot',
      credentials: wrapId('0d1f268f-407d-4cd9-a3c2-0f9671df0104'),
    ],
  ],
]

def isMaster = { String branch ->
  branch == "remotes/origin/master"
}

def deriveCommit = {
  commit = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
  mergeCommitParents = sh(returnStdout: true, script: "echo ${commit} | git log --pretty=%P -n 1 --date-order").trim()

  if (mergeCommitParents.length() > 40) { // is PR
    echo 'More than one merge commit parent signifies that the merge commit is not the actual PR commit'
    echo "Changing commit from '${commit}' to '${mergeCommitParents.take(40)}'"
    commit = mergeCommitParents.take(40)
  }
  commit
}

def buildAndPush = { Map registry, String commit ->
  String server = registry.name.contains('dockerhub') ? '' : 'quay.io'
  String registryPrefix = registry.name.contains('quay') ? 'quay.io/' : ''
  String imagePrefix = registry.name.contains('staging') ? 'deisci' : 'deis'
  String version = registry.name.contains('staging') ? "git-${commit}" : 'latest'

  sh """
    docker login -e="${registry.email}" -u="${registry.username}" -p="\${REGISTRY_PASSWORD}" ${server}
    REGISTRY=${registryPrefix} IMAGE_PREFIX=${imagePrefix} VERSION=${version} make build push
  """
}

node('linux') {
  stage('Checkout & Git Info') {
    checkout scm
    gitBranch = sh(returnStdout: true, script: 'git describe --all').trim()
    gitCommit = deriveCommit()
  }

  stage('Docker Build and Push - Quay.io') {
    def registry = isMaster(gitBranch) ? registries.quay.production : registries.quay.staging
    withCredentials(registry.credentials) {
      buildAndPush(registry, gitCommit.take(7))
    }
  }

  stage('Docker Build and Push - DockerHub') {
    def registry = isMaster(gitBranch) ? registries.dockerhub.production : registries.dockerhub.staging
    withCredentials(registry.credentials) {
      buildAndPush(registry, gitCommit.take(7))
    }
  }
}
