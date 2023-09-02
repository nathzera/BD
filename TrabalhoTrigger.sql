-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 02/09/2023 às 02:19
-- Versão do servidor: 10.4.28-MariaDB
-- Versão do PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `trab`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `autor`
--

CREATE TABLE `autor` (
  `id` int(11) NOT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `best_seller` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `autor`
--

INSERT INTO `autor` (`id`, `nome`, `best_seller`) VALUES
(1, 'Djonga', 'Ladrao');

-- --------------------------------------------------------

--
-- Estrutura para tabela `clientes`
--

CREATE TABLE `clientes` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) DEFAULT NULL,
  `cpf_cnpj` int(11) DEFAULT NULL,
  `email` varchar(250) DEFAULT NULL,
  `compra_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `clientes`
--

INSERT INTO `clientes` (`id`, `nome`, `cpf_cnpj`, `email`, `compra_id`) VALUES
(1, 'Nego Jairo', 21802, 'Cabecadebombom@email.com', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `comissoes`
--

CREATE TABLE `comissoes` (
  `id` int(11) NOT NULL,
  `valor_comissao` float DEFAULT NULL,
  `vendas_id` int(11) DEFAULT NULL,
  `vendedor_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `compras`
--

CREATE TABLE `compras` (
  `id` int(11) NOT NULL,
  `cliente_id` int(11) DEFAULT NULL,
  `data_compra` datetime DEFAULT NULL,
  `vendedor_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `compras`
--

INSERT INTO `compras` (`id`, `cliente_id`, `data_compra`, `vendedor_id`) VALUES
(1, 1, '2020-02-02 00:00:00', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `genero`
--

CREATE TABLE `genero` (
  `id` int(11) NOT NULL,
  `genero` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `genero`
--

INSERT INTO `genero` (`id`, `genero`) VALUES
(1, 'Romance');

-- --------------------------------------------------------

--
-- Estrutura para tabela `livro`
--

CREATE TABLE `livro` (
  `id` int(11) NOT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `autor_id` int(11) DEFAULT NULL,
  `midia` int(11) DEFAULT NULL,
  `lancamento` date DEFAULT NULL,
  `genero_id` int(11) DEFAULT NULL,
  `estoque` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `livro`
--

INSERT INTO `livro` (`id`, `nome`, `autor_id`, `midia`, `lancamento`, `genero_id`, `estoque`) VALUES
(1, 'Solto', 1, 1, '2020-02-02', 1, 492),
(2, 'Ballin', 1, 1, '2022-02-05', 1, 15);

-- --------------------------------------------------------

--
-- Estrutura para tabela `midia`
--

CREATE TABLE `midia` (
  `id` int(11) NOT NULL,
  `tipo_de_midia` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `midia`
--

INSERT INTO `midia` (`id`, `tipo_de_midia`) VALUES
(1, 'Fisica');

-- --------------------------------------------------------

--
-- Estrutura para tabela `vendas`
--

CREATE TABLE `vendas` (
  `id` int(11) NOT NULL,
  `livro_id` int(11) NOT NULL,
  `cliente_id` int(11) DEFAULT NULL,
  `loja` varchar(255) DEFAULT NULL,
  `valor` double(10,2) DEFAULT NULL,
  `desconto` double(10,2) DEFAULT NULL,
  `data_compra` datetime DEFAULT NULL,
  `compra_id` int(11) DEFAULT NULL,
  `quantidade` int(11) DEFAULT NULL,
  `vendedor_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `vendas`
--

INSERT INTO `vendas` (`id`, `livro_id`, `cliente_id`, `loja`, `valor`, `desconto`, `data_compra`, `compra_id`, `quantidade`, `vendedor_id`) VALUES
(1, 1, 1, 'Fisica', 100.00, 0.00, '2020-02-02 00:00:00', 1, 2, 1),
(2, 1, 1, 'Mk', 50.00, 0.00, '2022-09-01 21:10:15', 1, 3, 1),
(3, 1, 1, 'Fisica', 200.00, 10.00, '2022-05-05 16:00:10', 1, 5, 1),
(4, 2, 1, 'Fisica', 200.00, 10.00, '2022-05-05 16:00:10', 1, 5, 1);

--
-- Acionadores `vendas`
--
DELIMITER $$
CREATE TRIGGER `atualizar_estoque` AFTER INSERT ON `vendas` FOR EACH ROW BEGIN
  DECLARE produto_id INT;
  DECLARE quantidade_vendida INT;

  -- Obter o ID do livro e a quantidade vendida da nova venda
  SET produto_id = NEW.livro_id;
  SET quantidade_vendida = NEW.quantidade;

  -- Atualizar o estoque na tabela "livro"
  UPDATE livro
  SET estoque = estoque - quantidade_vendida
  WHERE id = produto_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `vendedores`
--

CREATE TABLE `vendedores` (
  `id` int(11) NOT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `cpf` int(11) DEFAULT NULL,
  `venda_id` int(11) DEFAULT NULL,
  `comissao_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `vendedores`
--

INSERT INTO `vendedores` (`id`, `nome`, `cpf`, `venda_id`, `comissao_id`) VALUES
(1, 'Jader', 201201, 1, 0);

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `autor`
--
ALTER TABLE `autor`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `comissoes`
--
ALTER TABLE `comissoes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_vendas_comissoes` (`vendas_id`);

--
-- Índices de tabela `compras`
--
ALTER TABLE `compras`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_clientes_compras` (`cliente_id`),
  ADD KEY `fk_vendedores_compras` (`vendedor_id`);

--
-- Índices de tabela `genero`
--
ALTER TABLE `genero`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `livro`
--
ALTER TABLE `livro`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_autor_livro` (`autor_id`),
  ADD KEY `fk_midia_livro` (`midia`),
  ADD KEY `fk_genero_livro` (`genero_id`);

--
-- Índices de tabela `midia`
--
ALTER TABLE `midia`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `vendas`
--
ALTER TABLE `vendas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_clientes_vendas` (`cliente_id`),
  ADD KEY `fk_compras_vendas` (`compra_id`),
  ADD KEY `fk_vendedores_vendas` (`vendedor_id`),
  ADD KEY `livro_id` (`livro_id`);

--
-- Índices de tabela `vendedores`
--
ALTER TABLE `vendedores`
  ADD PRIMARY KEY (`id`);

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `comissoes`
--
ALTER TABLE `comissoes`
  ADD CONSTRAINT `fk_vendas_comissoes` FOREIGN KEY (`vendas_id`) REFERENCES `vendas` (`id`);

--
-- Restrições para tabelas `compras`
--
ALTER TABLE `compras`
  ADD CONSTRAINT `fk_clientes_compras` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  ADD CONSTRAINT `fk_vendedores_compras` FOREIGN KEY (`vendedor_id`) REFERENCES `vendedores` (`id`);

--
-- Restrições para tabelas `livro`
--
ALTER TABLE `livro`
  ADD CONSTRAINT `fk_autor_livro` FOREIGN KEY (`autor_id`) REFERENCES `autor` (`id`),
  ADD CONSTRAINT `fk_genero_livro` FOREIGN KEY (`genero_id`) REFERENCES `genero` (`id`),
  ADD CONSTRAINT `fk_midia_livro` FOREIGN KEY (`midia`) REFERENCES `midia` (`id`);

--
-- Restrições para tabelas `vendas`
--
ALTER TABLE `vendas`
  ADD CONSTRAINT `fk_clientes_vendas` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  ADD CONSTRAINT `fk_compras_vendas` FOREIGN KEY (`compra_id`) REFERENCES `compras` (`id`),
  ADD CONSTRAINT `fk_vendedores_vendas` FOREIGN KEY (`vendedor_id`) REFERENCES `vendedores` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
