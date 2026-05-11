# Patch F2 — CRM Frontend (Onda 1)

> Replicação do hardening do admin no CRM + correções específicas do CRM (EtapasPipeline 3-dialog, slotProps deprecated, ReadOnlyField shared).

## Escopo

- **Locale pt-BR DataGrid v8**: workaround necessário porque DataGrid v8 NÃO faz merge entre `localeText` prop e `MuiDataGrid.defaultProps.localeText` do tema. Aplicado `localeText` direto em todas as 12 ListPages com keys `paginationRowsPerPage` + `paginationDisplayedRows`.
- **Sidebar responsiva**: `Drawer` `temporary` em `< md`, hamburger em `Header.tsx`, drawer fecha em nav click; `MainLayout` width responsiva
- **Header a11y**: `aria-label` em IconButtons; subtitle xs:none; ícone título xs:none
- **EtapasPipelinePage**: removida coluna "Ações"; row click → `EtapaPipelineDetailDialog` (NEW); 3-dialog conforme
- **`inputProps` → `slotProps.htmlInput`** (MUI 7) em ~17 ocorrências: `EnderecoForm.tsx`, `ContatosTab.tsx`, `EnderecosTab.tsx`
- **`ReadOnlyField`** extraído para `components/common/` + adoção em 3 DetailDialogs
- **Type augmentation `theme.palette.accent`** (sem mais cast `as any`)

## Arquivos

### Tema + layout (sidebar/header responsivos)
```
crm.dev.indiolab.com.br/crm-web/src/presentation/theme/theme.ts
crm.dev.indiolab.com.br/crm-web/src/presentation/components/layout/Sidebar.tsx
crm.dev.indiolab.com.br/crm-web/src/presentation/components/layout/MainLayout.tsx
crm.dev.indiolab.com.br/crm-web/src/presentation/components/layout/Header.tsx
```

### Componentes shared + deprecation MUI 7
```
crm.dev.indiolab.com.br/crm-web/src/presentation/components/common/ReadOnlyField.tsx          # NEW
crm.dev.indiolab.com.br/crm-web/src/presentation/components/common/index.ts                   # export ReadOnlyField
crm.dev.indiolab.com.br/crm-web/src/presentation/components/common/EnderecoForm.tsx           # inputProps → slotProps.htmlInput
crm.dev.indiolab.com.br/crm-web/src/presentation/components/common/ContatosTab.tsx            # idem
crm.dev.indiolab.com.br/crm-web/src/presentation/components/common/EnderecosTab.tsx           # idem
```

### EtapasPipeline 3-dialog
```
crm.dev.indiolab.com.br/crm-web/src/presentation/pages/dominios/EtapasPipelinePage.tsx
crm.dev.indiolab.com.br/crm-web/src/presentation/pages/dominios/EtapaPipelineDetailDialog.tsx # NEW
crm.dev.indiolab.com.br/crm-web/src/presentation/pages/dominios/DominioCrudPage.tsx           # locale text
```

### ListPages CRM com locale fix
```
crm.dev.indiolab.com.br/crm-web/src/presentation/pages/crm/AtividadesListPage.tsx
crm.dev.indiolab.com.br/crm-web/src/presentation/pages/crm/CampanhasListPage.tsx
crm.dev.indiolab.com.br/crm-web/src/presentation/pages/crm/ComodatosListPage.tsx
crm.dev.indiolab.com.br/crm-web/src/presentation/pages/crm/DespesasListPage.tsx
crm.dev.indiolab.com.br/crm-web/src/presentation/pages/crm/LeadsListPage.tsx
crm.dev.indiolab.com.br/crm-web/src/presentation/pages/crm/OportunidadesListPage.tsx
crm.dev.indiolab.com.br/crm-web/src/presentation/pages/crm/QualificarLeadsPage.tsx
crm.dev.indiolab.com.br/crm-web/src/presentation/pages/crm/VisitasListPage.tsx
```

### DetailDialogs adotando ReadOnlyField shared
```
crm.dev.indiolab.com.br/crm-web/src/presentation/pages/crm/components/ComodatoDetailDialog.tsx
crm.dev.indiolab.com.br/crm-web/src/presentation/pages/crm/components/DespesaRelatorioDetailDialog.tsx
crm.dev.indiolab.com.br/crm-web/src/presentation/pages/crm/components/VisitaDetailDialog.tsx
```

### Outros (Auth/Service)
```
crm.dev.indiolab.com.br/crm-web/src/application/contexts/AuthContext.tsx
crm.dev.indiolab.com.br/crm-web/src/infrastructure/api/empresaService.ts
crm.dev.indiolab.com.br/crm-web/src/infrastructure/auth/authApi.ts
```

## Comando git

```bash
git add crm.dev.indiolab.com.br/crm-web/src/

git status
git diff --cached --stat
```

## Mensagem de commit sugerida

```
feat(crm-web): locale pt-BR + responsive layout + EtapasPipeline 3-dialog (Onda 1)

- locale pt-BR direto em cada DataGrid v8 (workaround: prop não faz merge com defaultProps do tema)
- sidebar responsiva: Drawer temporary < md + hamburger + auto-close em nav click
- Header: aria-label em IconButtons; subtitle/ícone xs:none; noWrap title
- EtapasPipelinePage: remoção da coluna "Ações" + row click → EtapaPipelineDetailDialog (3-dialog conforme)
- inputProps → slotProps.htmlInput (MUI 7 deprecation) em EnderecoForm, ContatosTab, EnderecosTab
- ReadOnlyField extraído para components/common/ + adoção em ComodatoDetailDialog, DespesaRelatorioDetailDialog, VisitaDetailDialog
- type augmentation: removido (theme.palette as any).accent

Validado: tsc clean, console 0 errors, login + leads/oportunidades/atividades funcionais,
mobile 375px com sidebar Drawer + DataGrid renderizando.
```

## Validação pós-commit

```bash
cd crm.dev.indiolab.com.br/crm-web && npx tsc --noEmit
```
