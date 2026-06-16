# 🏗️ WORKFLOW — Cómo trabajar en Cubículo Digital

> Esto es una guía para **cualquier persona del equipo**, incluso si sabés muy poco de programación.
> Si algo no se entiende, **preguntá sin miedo**. No hay preguntas tontas.

---

## 📖 ÍNDICE

1. [¿Qué es Cubículo Digital?](#1-qué-es-cubículo-digital)
2. [El Tablero — GitHub Projects](#2-el-tablero--github-projects)
3. [Setup único (solo la primera vez)](#3-setup-único-solo-la-primera-vez)
4. [Flujo diario — 6 pasos](#4-flujo-diario--6-pasos)
5. [Trabajar con Agentes de IA (OpenCode)](#5-trabajar-con-agentes-de-ia-opencode)
6. [Reglas de oro (NO NEGOCIABLE)](#6-reglas-de-oro-no-negociable)
7. [Problemas comunes y cómo salir](#7-problemas-comunes-y-cómo-salir)
8. [Glosario](#8-glosario)

---

## 1. ¿QUÉ ES CUBÍCULO DIGITAL?

Es una aplicación web que **convierte el conocimiento de una empresa en documentos útiles** usando inteligencia artificial. Hacés una entrevista, contestás preguntas, y el sistema genera un reporte completo con análisis de 8 departamentos distintos.

Esto es un **hackathon** — tenemos 6 días para construirlo y presentarlo.
Todo el equipo trabaja en el mismo repositorio de GitHub.

---

## 2. EL TABLERO — GITHUB PROJECTS

> El tablero está acá: [https://github.com/orgs/cubiculo-digital/projects/1](https://github.com/orgs/cubiculo-digital/projects/1)

Es como un **Trello** o un pizarrón con tarjetas. Cada tarjeta es una tarea.

### Columnas del tablero

| Columna | Qué significa |
|---------|---------------|
| 📋 **Todo** | Tareas que esperan ser hechas |
| 👨‍💻 **In Progress** | Alguien ya está trabajando en esto |
| ✅ **Done** | Tarea terminada y mergeada |

### ¿Cómo agarro una tarea?

1. Entrá al tablero → [https://github.com/orgs/cubiculo-digital/projects/1](https://github.com/orgs/cubiculo-digital/projects/1)
2. Buscá en la columna **"Todo"** una tarea que NO tenga nadie asignado
3. Hacé clic en la tarjeta para abrir el issue
4. En la página del issue, a la derecha, hacé clic en **"Assign yourself"**
5. Volvé al tablero, arrastrá la tarjeta a **"In Progress"**
6. Listo, ya es tuya. Ahora seguí el [Flujo diario](#4-flujo-diario--6-pasos)

> ⚠️ **Importante:** Solo trabajá en UNA tarea a la vez. Si te trabás, pedí ayuda antes de agarrar otra.

### Campos personalizados

Cada tarjeta tiene etiquetas que le ponen los jefes:

| Campo | Qué es | Ejemplo |
|-------|--------|---------|
| **Priority** | Qué tan urgente es | 🔴 P0 (urgentísimo), 🟡 P1 (importante), 🟢 P2 (si hay tiempo) |
| **Track** | De qué tipo es la tarea | Security, Feature, Testing, Docs |
| **Day** | En qué día del hackathon se hace | 1, 2, 3, 4, 5, 6 |
| **Department** | Qué área toca | Tecnología, Ventas, Marketing... |
| **Estimate** | Cuánto tiempo lleva (en horas) | 1h, 2h, 3h... |

No te preocupes por esto — lo usan los líderes para organizar. Vos solo preocupate de hacer la tarea.

---

## 3. SETUP ÚNICO (SOLO LA PRIMERA VEZ)

Esto se hace **una sola vez**. Si ya lo hiciste, pasá al [Flujo diario](#4-flujo-diario--6-pasos).

### 3.1. Instalar programas

Necesitás estos 3 programas. Si no los tenés, descargalos:

| Programa | Para qué sirve | Link de descarga |
|----------|----------------|------------------|
| **Git** | Para bajar y subir código | [https://git-scm.com/downloads](https://git-scm.com/downloads) — siguiente, siguiente, instalar |
| **Node.js** | Para que funcione el proyecto | [https://nodejs.org/](https://nodejs.org/) — bajar la versión LTS (20.x) |
| **pnpm** | Para instalar librerías | Abrí terminal y copiá este comando: `npm install -g pnpm` |

> ¿No sabés qué es la "terminal" o "consola"? Es una ventana negra donde se escriben comandos.
> En Windows se llama "CMD" o "PowerShell". En Mac se llama "Terminal".

### 3.2. Configurar Git por primera vez

Abrí la terminal y copiá estos comandos (UNO por uno, presionando Enter después de cada uno):

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"
```

Poné tu nombre real y el mail que usás en GitHub.

### 3.3. Clonar el repositorio (bajar el proyecto a tu compu)

1. Andá a [https://github.com/cubiculo-digital/Cubiculo-Digital](https://github.com/cubiculo-digital/Cubiculo-Digital)
2. Hacé clic en el botón verde **"Code"**
3. Copiá la URL que aparece
4. En la terminal, escribí:

```bash
git clone <LA-URL-QUE-COPIASte>
cd Cubiculo-Digital
```

> Si te pide usuario y contraseña, usá tu usuario de GitHub y un **token** (no tu contraseña).
> Para crear un token: GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic) → Generate new token → marcar `repo` → Generate → copiar el token.

### 3.4. Instalar dependencias

Ya estás dentro de la carpeta `Cubiculo-Digital`. Ahora ejecutá:

```bash
pnpm install
```

Esto puede tardar un rato. Cuando termine, el proyecto está listo.

### 3.5. Verificar que funciona

```bash
pnpm run dev
```

Si ves algo como `Server running on http://localhost:3000`, **funciona**. Apretá Ctrl+C para detenerlo.

---

## 4. FLUJO DIARIO — 6 PASOS

Este es el ritual que repetís **cada vez que trabajás en una tarea nueva**.

### ▶️ Paso 1: "Traete lo último"

Siempre, **SIEMPRE**, antes de arrancar, asegurate de tener la última versión del proyecto:

```bash
git checkout dev-2
git pull origin dev-2
```

> `git checkout` cambia de rama. `git pull` trae los cambios nuevos.
> Hacé esto aunque hayas trabajado ayer. Tu compu se puede haber quedado vieja.

### ▶️ Paso 2: "Creá tu rama"

Una "rama" es como tu **espacio de trabajo personal**. Nadie más toca tu rama.

```bash
git checkout -b feat/tu-nombre-breve-de-tarea
```

Ejemplos de nombres de rama:
- `feat/password-reset` (si estás haciendo la pantalla de reset de contraseña)
- `fix/login-error` (si estás arreglando un error en el login)
- `docs/readme` (si estás escribiendo documentación)

> **Regla:** el nombre debe describir la tarea en pocas palabras, en inglés, separado por guiones.

### ▶️ Paso 3: "Codeá"

Abrí el proyecto en tu editor (VS Code, WebStorm, etc.) y hacé los cambios que necesites.

Si usás VS Code, podés abrirlo desde la terminal:
```bash
code .
```

No sabés qué escribir exactamente? No pasa nada — **los agentes de IA te ayudan** (más abajo se explica).

### ▶️ Paso 4: "Guardá y confirmá"

Cuando terminaste un cambio (o llegaste a un punto donde querés guardar), ejecutá:

```bash
git add .
git commit -m "feat: descripción corta de lo que hiciste"
```

Ejemplos de commits:
- `git commit -m "feat: agregar formulario de reset password"`
- `git commit -m "fix: corregir error cuando el email no existe"`
- `git commit -m "chore: actualizar dependencias"`

> **Tip:** Hacé commits **seguido**. No esperes a tener todo listo. Cada vez que termines una parte, commit.
> Es como "guardar partida" en un videojuego.

### ▶️ Paso 5: "Subilo"

Subís tus cambios a GitHub para que no se pierdan:

```bash
git push origin feat/tu-nombre-de-rama
```

> Si es la primera vez que subís esta rama, git te va a pedir que uses `--set-upstream`.
> Copiá el comando que te sugiere el mismo git.

### ▶️ Paso 6: "Pedí que lo revisen" (Pull Request)

Ahora tenés que pedir que **revisen tu trabajo** antes de que pase al proyecto principal.

1. Andá a [https://github.com/cubiculo-digital/Cubiculo-Digital](https://github.com/cubiculo-digital/Cubiculo-Digital)
2. Te va a aparecer un banner amarillo que dice **"tu-rama had recent pushes"** → hacé clic en **"Compare & pull request"**
3. Llená el formulario:
   - **Base:** `dev-2` (NO `dev` ni `main`)
   - **Compare:** tu rama (ej: `feat/password-reset`)
   - **Title:** Poné el título del issue
   - **Description:** Describí qué hiciste
4. Hacé clic en **"Create pull request"**

O desde la terminal:
```bash
gh pr create --base dev-2 --title "Título de tu tarea" --body "Descripción de lo que hiciste"
```

> Después de crear el PR, **GitHub automáticamente corre unos chequeos** (CI).
> Esperá a que se pongan verdes antes de pedir revisión.

### 🎯 Después de todo esto

- ✅ Pasá la tarjeta del tablero a **"In Progress"** (si no lo hiciste antes)
- ✅ Cuando te aprueben el PR, mergealo
- ✅ Pasá la tarjeta a **"Done"**
- ✅ Agarrá la siguiente tarea de la columna **"Todo"**

---

## 5. TRABAJAR CON AGENTES DE IA (OPENCODE)

> Acá hay una confusión común. **No confundas estos "agentes" con los del producto.**
>
> Los **8 agentes del producto** son el software que analiza empresas (Ventas, RRHH, etc.).
> Los **agentes de IA (OpenCode)** son asistentes que te ayudan a programar.
> Son cosas totalmente distintas.

### ¿Qué es OpenCode?

Es un programa que corre en tu terminal y te da **asistentes de IA** para programar.
Le decís "hacé tal cosa" y él te ayuda a escribir el código.

### Los agentes disponibles

| Agente | Para qué usarlo |
|--------|-----------------|
| 🧠 **Plan Agent** | Antes de escribir código, para pensar y planificar cómo hacer la tarea |
| 🛠️ **Build Agent** | Para escribir código. Decile "implementá tal cosa" y él lo hace |
| 👁️ **Code Reviewer** | Para revisar el código que ya escribiste y ver si hay errores |

### Cómo empezar a usarlo

En la terminal, dentro de la carpeta del proyecto, escribí:

```bash
opencode
```

Esto abre la consola de OpenCode. Ahí podés empezar a hablar con los agentes.

### Qué decirle al agente

Empezá siempre con el contexto del proyecto. Decile algo como:

> "Hola, trabajamos en Cubículo Digital. Soy un desarrollador nuevo en el equipo.
> Necesito implementar [tu tarea]. Primero leé las reglas del proyecto y las bitácoras.
> Después ayudame a planificar y escribir el código."

### Skills (habilidades especiales)

A veces el agente necesita **skills** específicas para ciertas tareas:

| Skill | Cuándo usarla |
|-------|---------------|
| `@feature-implementation` | Cuando vas a implementar una **nueva funcionalidad** completa |
| `@customize-opencode` | Solo si hay que cambiar cómo funciona el agente mismo (casi nunca) |

Si no sabés cuál usar, no pasa nada. El agente te va a preguntar o a elegir solo.

### Las Bitácoras — "el cuaderno del proyecto"

Son archivos que **registran todo lo que pasó**:

| Archivo | Qué contiene |
|---------|-------------|
| `.bitacoras/actual.md` | **Lo primero que tenés que leer.** Dice en qué estamos trabajando HOY |
| `.bitacoras/index.md` | Historial de todas las tareas completadas |
| `.bitacoras/###-nombre.md` | Bitácoras detalladas de cada tarea |

**Antes de arrancar cualquier cosa, leé `actual.md`.** Ahí dice qué pasó la última vez y qué sigue.

```bash
# Para leer la bitácora actual desde la terminal:
cat .bitacoras/actual.md
```

### Prompts útiles (mensajes para el agente)

> **Prompt** = el mensaje que le escribís al agente. Es como darle instrucciones a un ayudante.

**Para arrancar una tarea nueva:**
> "Leé .bitacoras/actual.md y después .agent/rules/global-context/global-context.md. Ahora ayudame a planificar [tu tarea]."

**Para pedir ayuda con código:**
> "Necesito hacer [X]. Mostrame cómo o escribilo vos."

**Para revisar lo que hiciste:**
> "Revisá el código que acabo de escribir. ¿Hay errores? ¿Se puede mejorar?"

### Reglas del agente (.agent/rules/)

El proyecto tiene reglas que los agentes **leen automáticamente**. No necesitás memorizarlas. El agente sabe que:
- No debe trabajar en `main` ni `dev`
- Debe seguir el flujo de Git
- Debe respetar el diseño visual del proyecto
- Debe revisar las bitácoras antes de arrancar

Vos solo preocupate de **describir bien la tarea**. El agente se encarga del resto.

---

## 6. REGLAS DE ORO (NO NEGOCIABLE)

Estas reglas **no se rompen**. Si las rompés, algo se va a romper.

| Regla | Por qué |
|-------|---------|
| ⛔ **NUNCA trabajes en `main` ni `dev`** | Esas ramas son sagradas. Siempre creá tu rama desde `dev-2` |
| ⛔ **NUNCA mergees sin aprobación** | Alguien tiene que revisar tu PR antes de que pase |
| ⛔ **NUNCA mergees si el CI está rojo** | "Después lo arreglo" = bugs en producción. El CI tiene que estar verde |
| ✅ **SIEMPRE hacé `git pull` antes de arrancar** | Tu compu se queda vieja. Traé lo último primero |
| ✅ **SIEMPRE hacé `git push` antes de pausa/comida** | No pierdas tu trabajo. Subilo aunque no esté terminado |
| ✅ **SIEMPRE leé `.bitacoras/actual.md` antes de empezar** | Sabé en qué va el proyecto hoy |

> Si rompés una regla, **avisá al equipo rápido**. No te escondas. Todos nos equivocamos, lo importante es avisar.

---

## 7. PROBLEMAS COMUNES Y CÓMO SALIR

### "Permission denied" (me dice que no tengo permiso)

**Causa:** No estás conectado a GitHub, o no tenés acceso al repo.

**Solución:**
```bash
# Verificá si estás conectado:
gh auth status

# Si no estás conectado:
gh auth login
# Seguí las instrucciones en pantalla
```

### "Merge conflict" (conflicto al hacer pull)

**Causa:** Alguien tocó el mismo archivo que vos, y git no sabe cuál quedarse.

**Solución para principiantes (la fácil):**
```bash
# Descartá todo y poné tu versión encima (preguntá antes de hacer esto)
git checkout --theirs .
git add .
git commit -m "fix: resolver conflictos"
```

> Pedí ayuda a un compañero la primera vez que te pase. Es normal.

### "CI falló" (el chequeo automático dio error)

**Causa:** Tu código tiene algún error (sintaxis, test que no pasa, etc.)

**Solución:**
1. Andá a tu PR en GitHub
2. Abajo, en los checks, hacé clic en "Details" del que falló
3. Leé el error (ahí dice exactamente qué está mal)
4. Corregilo, commit, push de nuevo

> Si no entendés el error, pedí ayuda. Es parte del aprendizaje.

### Me equivoqué de rama

```bash
# Si querés borrar la rama que creaste por error:
git checkout dev-2
git branch -D feat/nombre-erroneo

# Ahora creá la correcta:
git checkout -b feat/nombre-correcto
```

### El agente de IA no responde o hace cosas raras

1. Apretá **Ctrl+C** para salir
2. Escribí `opencode` de nuevo
3. Si sigue, preguntá en el grupo del equipo

### "No sé qué escribir"

1. Leé la tarea en el tablero de GitHub
2. Buscá si hay una rama similar ya terminada para ver ejemplos
3. Preguntale al agente de IA: "Ayudame a planificar esto"
4. Si no funciona, **preguntá a un compañero**

---

## 8. GLOSARIO

> Palabras que aparecen en esta guía y su significado simple.

| Palabra | Significado |
|---------|-------------|
| **Rama (branch)** | Una copia del proyecto donde podés hacer cambios sin afectar a nadie |
| **Commit** | "Guardar partida". Un punto de control de tu trabajo |
| **Push** | Subir tus commits a GitHub para que no se pierdan |
| **Pull** | Bajar los cambios de otros a tu compu |
| **Pull Request (PR)** | Un pedido para que tu código pase a la rama principal |
| **Merge** | Cuando aprueban tu PR y tu código se suma al proyecto |
| **CI** | Chequeos automáticos que revisan que tu código no tenga errores |
| **Clonar** | Bajar el proyecto entero a tu compu por primera vez |
| **Repositorio (repo)** | La carpeta del proyecto en GitHub |
| **Dependencias** | Librerías externas que el proyecto necesita. Se instalan con `pnpm install` |
| **Terminal / Consola** | Ventana negra donde se escriben comandos |
| **Agente de IA** | Un asistente inteligente que te ayuda a programar |
| **Skill** | Una habilidad especial que el agente puede tener para ciertas tareas |
| **Prompt** | El mensaje que le escribís al agente para pedirle algo |
| **Bitácora** | Archivo `.md` que cuenta qué pasó en el proyecto día a día |
| **OpenCode** | El programa que corre los agentes de IA en tu terminal |
| **Editor (VS Code)** | Programa donde se escribe el código |
| **Git** | Programa que guarda el historial de cambios del proyecto |
| **GitHub** | Página web donde está guardado el proyecto en la nube |

---

> ¿Algo no quedó claro? Preguntá. **No hay preguntas tontas, solo tontos que no preguntan.**
>
> — El equipo de Cubículo Digital 🚀
