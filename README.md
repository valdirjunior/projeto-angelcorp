# AngelDesk

AngelDesk é uma aplicação web fullstack para gerenciamento de chamados técnicos internos, desenvolvida como trabalho da disciplina de Infraestrutura e Serviços Web.

O projeto utiliza uma arquitetura em três camadas, com frontend, backend e banco de dados executando em containers. A aplicação pode ser executada tanto com Docker Compose quanto em um cluster Kubernetes local com Kind.

---

## Arquitetura

A aplicação é composta por três serviços principais:

- **Frontend:** React + Vite, servido por Nginx.
- **Backend:** Node.js + Express, responsável pela API REST.
- **Banco de dados:** PostgreSQL 16.

No ambiente Docker Compose, o acesso externo ocorre por meio do frontend em:

```text
http://angeldesk.local
```

O Nginx do frontend também atua como reverse proxy, encaminhando requisições iniciadas com `/api` para o backend.

Fluxo simplificado:

```text
Navegador
   |
   v
Frontend Nginx
   |-- /       -> Aplicação React
   |-- /api    -> Backend Express
                      |
                      v
                  PostgreSQL
```

---

## Tecnologias utilizadas

- Docker
- Docker Compose
- Kubernetes
- Kind
- Node.js
- Express
- React
- Vite
- Nginx
- PostgreSQL

---

## Estrutura do projeto

```text
projeto-angelcorp/
├── backend/
│   ├── Dockerfile
│   ├── package.json
│   ├── server.js
│   └── src/
│       ├── config/
│       ├── controllers/
│       └── routes/
├── db/
│   └── init/
│       └── init.sql
├── frontend/
│   ├── Dockerfile
│   ├── index.html
│   ├── nginx.conf
│   ├── public/
│   └── src/
├── k8s/
├── scripts/
├── docker-compose.yml
└── README.md
```

---

## Funcionalidades

A aplicação permite gerenciar chamados técnicos com os seguintes campos:

- título;
- descrição;
- status;
- prioridade;
- data de criação.

A API possui operações básicas de CRUD:

| Método | Rota | Descrição |
|---|---|---|
| GET | `/tickets` | Lista todos os tickets |
| GET | `/tickets/:id` | Busca um ticket por ID |
| POST | `/tickets` | Cria um novo ticket |
| PUT | `/tickets/:id` | Atualiza um ticket existente |
| DELETE | `/tickets/:id` | Remove um ticket |

Quando acessada pelo navegador via Nginx, a API fica disponível com o prefixo `/api`.

Exemplo:

```text
http://angeldesk.local/api/tickets
```

---

## Pré-requisitos

Para executar o projeto, é necessário ter instalado:

- Docker Desktop;
- Docker Compose;
- WSL ou terminal Linux;
- kubectl;
- Kind.

Para a execução com Docker Compose, basta ter o Docker Desktop em funcionamento.

Para a execução com Kubernetes, também é necessário que o `kind` e o `kubectl` estejam instalados e configurados.

---

## Clonando o projeto

```bash
git clone <https://github.com/valdirjunior/projeto-angelcorp.git>
cd projeto-angelcorp
```

Depois de clonar, garanta permissão de execução para os scripts:

```bash
chmod +x scripts/*.sh
```

---

## Configuração do DNS local

Para acessar a aplicação pelo domínio local `angeldesk.local`, adicione a seguinte entrada no arquivo `hosts` do Windows:

```text
127.0.0.1 angeldesk.local
```

Caminho do arquivo no Windows:

```text
C:\Windows\System32\drivers\etc\hosts
```

Após alterar o arquivo, pode ser necessário limpar o cache DNS:

```cmd
ipconfig /flushdns
```

Caso esteja usando WSL e queira testar o domínio também dentro do terminal Linux, adicione a entrada no `/etc/hosts` do WSL:

```bash
echo "127.0.0.1 angeldesk.local" | sudo tee -a /etc/hosts
```

---

## Execução com Docker Compose

Antes de executar, certifique-se de que o Docker Desktop está iniciado.

Para subir a aplicação:

```bash
./scripts/compose-up.sh
```

A aplicação ficará disponível em:

```text
http://angeldesk.local
```

A API poderá ser testada em:

```text
http://angeldesk.local/api/tickets
```

Para validar rapidamente a execução:

```bash
./scripts/compose-check.sh
```

Para parar a aplicação:

```bash
./scripts/compose-down.sh
```

Para recriar a aplicação do zero, incluindo o volume do banco:

```bash
./scripts/compose-reset.sh
```

Esse comando remove o volume do PostgreSQL e recria a base de dados usando o arquivo:

```text
db/init/init.sql
```

---

## Observação sobre Nginx local

Como a aplicação utiliza a porta 80 para permitir o acesso por `angeldesk.local`, pode haver conflito caso exista um Nginx local ativo no WSL/Ubuntu.

Para evitar esse problema, os scripts de execução verificam se existe um Nginx local ocupando a porta 80. Caso exista, ele é parado temporariamente antes da aplicação subir.

Quando a aplicação é encerrada pelo script `compose-down.sh`, o Nginx local é restaurado caso estivesse ativo anteriormente.

Scripts relacionados:

```bash
./scripts/prepare-host.sh
./scripts/restore-host.sh
```

Caso queira verificar manualmente se existe algum processo utilizando a porta 80:

```bash
sudo ss -ltnp | grep ':80'
```

---

## Execução com Kubernetes

O projeto também pode ser executado em Kubernetes usando Kind.

Para recriar o ambiente Kubernetes do zero:

```bash
./scripts/k8s-reset.sh
```

Esse script:

1. remove o cluster Kind anterior, se existir;
2. cria o cluster novamente;
3. constrói as imagens Docker do frontend e backend;
4. carrega as imagens no Kind;
5. aplica os manifests Kubernetes;
6. inicializa o banco com um Job;
7. exibe os pods e services criados.

Para subir sem remover o cluster existente:

```bash
./scripts/k8s-up.sh
```

Para acessar a aplicação no Kubernetes, execute o port-forward:

```bash
./scripts/k8s-port-forward.sh
```

A aplicação ficará disponível em:

```text
http://localhost:8081
```

A API poderá ser testada em:

```text
http://localhost:8081/api/tickets
```

Para verificar os recursos Kubernetes:

```bash
./scripts/k8s-check.sh
```

Com o port-forward ativo, também é possível testar a aplicação via HTTP:

```bash
./scripts/k8s-http-check.sh
```

Para remover os recursos da aplicação no Kubernetes:

```bash
./scripts/k8s-down.sh
```

---

## Recursos Kubernetes utilizados

O projeto utiliza os seguintes recursos Kubernetes:

- Deployment para o frontend;
- Deployment para o backend;
- Deployment para o PostgreSQL;
- Service para comunicação entre os serviços;
- Secret para credenciais do banco;
- ConfigMap para configurações do backend;
- PersistentVolume;
- PersistentVolumeClaim;
- Job para inicialização do banco de dados.

---

## Organização dos Services

No Kubernetes, o frontend é o único serviço exposto para acesso externo.

O backend e o banco permanecem internos ao cluster, usando services do tipo `ClusterIP`.

Fluxo no Kubernetes:

```text
Navegador
   |
   v
frontend-service
   |
   v
Nginx do frontend
   |-- /       -> React
   |-- /api    -> backend-service
                      |
                      v
                  db-service
```

---

## Banco de dados

O banco utilizado é PostgreSQL 16.

A tabela principal é `tickets`.

Estrutura:

```sql
CREATE TABLE IF NOT EXISTS tickets (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    descricao TEXT NOT NULL,
    status VARCHAR(50) NOT NULL,
    prioridade VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

No Docker Compose, a tabela é criada automaticamente por meio do arquivo:

```text
db/init/init.sql
```

No Kubernetes, a inicialização é feita por meio de um Job:

```text
k8s/db-init-job.yaml
```

O Job utiliza uma inserção idempotente, evitando duplicar o ticket inicial caso seja executado novamente.

---

## Variáveis de ambiente do backend

O backend espera as seguintes variáveis:

```env
DB_HOST=db-service
DB_PORT=5432
DB_USER=angeluser
DB_PASSWORD=angelpass
DB_NAME=angeldesk
PORT=3000
```

Um exemplo está disponível em:

```text
backend/.env.example
```

No Docker Compose, essas variáveis são definidas diretamente no arquivo:

```text
docker-compose.yml
```

No Kubernetes, parte das configurações fica no ConfigMap e parte no Secret:

```text
k8s/backend-configmap.yaml
k8s/db-secret.yaml
```

---

## Scripts disponíveis

| Script | Função |
|---|---|
| `compose-up.sh` | Prepara o host e sobe a aplicação com Docker Compose |
| `compose-down.sh` | Para os containers e restaura o ambiente local |
| `compose-reset.sh` | Remove containers e volume do banco, recriando tudo do zero |
| `compose-check.sh` | Testa frontend e API no Docker Compose |
| `prepare-host.sh` | Verifica e libera a porta 80 caso exista Nginx local ativo |
| `restore-host.sh` | Restaura o Nginx local caso ele estivesse ativo antes |
| `k8s-build-images.sh` | Constrói e carrega as imagens Docker no Kind |
| `k8s-up.sh` | Sobe os recursos da aplicação no Kubernetes |
| `k8s-reset.sh` | Recria o cluster Kind e sobe tudo do zero |
| `k8s-down.sh` | Remove os recursos Kubernetes da aplicação |
| `k8s-port-forward.sh` | Expõe o frontend Kubernetes em `localhost:8081` |
| `k8s-check.sh` | Lista os recursos Kubernetes criados |
| `k8s-http-check.sh` | Testa frontend e API via HTTP no Kubernetes |

---

## Testes rápidos

### Docker Compose

Subir a aplicação:

```bash
./scripts/compose-up.sh
```

Validar:

```bash
./scripts/compose-check.sh
```

Testar manualmente a API:

```bash
curl http://angeldesk.local/api/tickets
```

Parar:

```bash
./scripts/compose-down.sh
```

---

### Kubernetes

Recriar o cluster e subir tudo do zero:

```bash
./scripts/k8s-reset.sh
```

Abrir o acesso local ao frontend:

```bash
./scripts/k8s-port-forward.sh
```

Em outro terminal, validar:

```bash
./scripts/k8s-http-check.sh
```

Testar manualmente a API:

```bash
curl http://localhost:8081/api/tickets
```

---

## Extras implementados

Além dos requisitos principais, o projeto inclui:

- build multi-stage no frontend;
- Nginx como servidor de arquivos estáticos;
- Nginx como reverse proxy para `/api`;
- DNS local com `angeldesk.local`;
- scripts de automação;
- scripts de validação;
- Secret e ConfigMap no Kubernetes;
- PV e PVC para persistência do PostgreSQL;
- Job Kubernetes para inicialização do banco;
- healthcheck no Docker Compose;
- endpoint `/health` no backend;
- frontend, backend e banco separados em containers;
- backend e banco mantidos como serviços internos no Kubernetes.

---

## Replicação em outro ambiente

Para replicar o projeto em outra máquina:

1. Instale Docker Desktop.
2. Instale Kind e kubectl, caso deseje executar a versão Kubernetes.
3. Clone este repositório.
4. Entre na pasta do projeto.
5. Dê permissão de execução aos scripts:

```bash
chmod +x scripts/*.sh
```

6. Configure o domínio local `angeldesk.local` no arquivo `hosts`, se desejar usar o acesso por nome.
7. Execute com Docker Compose:

```bash
./scripts/compose-up.sh
```

Ou execute com Kubernetes:

```bash
./scripts/k8s-reset.sh
./scripts/k8s-port-forward.sh
```

---

## Autor

Valdir Rugiski Junior
