CREATE TABLE alunos (
    aluno_id      INT AUTO_INCREMENT PRIMARY KEY,
    nome          VARCHAR(100)    NOT NULL,
    sobrenome     VARCHAR(100)    NOT NULL,
    endereco      VARCHAR(200)    NULL,
    cidade        VARCHAR(100)    NULL,
    cep           CHAR(8)         NULL COMMENT 'Somente números, ex: 01001000',
    estado        CHAR(2)         NULL COMMENT 'Sigla UF',
    email         VARCHAR(255)    NULL UNIQUE,
    telefone      VARCHAR(15)     NULL COMMENT 'Ex: (11) 98765-4321',
    host          VARCHAR(100)    NULL COMMENT 'Nome do computador ou origem do cadastro',
    
    criado_em     TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_nome_sobrenome (nome, sobrenome),
    INDEX idx_cidade (cidade),
    INDEX idx_email (email)
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci;
