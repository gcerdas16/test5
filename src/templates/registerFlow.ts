import { addKeyword, EVENTS } from "@builderbot/bot";
import sheetsService from "../services/sheetsService";

const registerFlow = addKeyword(EVENTS.ACTION)
  .addAnswer(
    `🍡 ¡Hola! Gracias por comunicarte con MOSHII, Soy Emma ¿En qué puedo asistirle hoy? 😊`,
    null,
    async (ctx, ctxFn) => {
      await sheetsService.createUser(ctx.from, ctx.name,);
      //await ctxFn.flowDynamic(
      //  "Excelente! Tus datos ya fueron cargados, ya podes comenzar a utilizar el bot"
      //);
    }
  );

export { registerFlow };
